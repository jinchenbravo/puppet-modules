Puppet::Type.type(:hdfsfile).provide(:posix) do
    desc "Normal Unix-like POSIX support for hdfs file management."
    mk_resource_methods
    def create
        x=resource[:name]
        system("su - hdfs -c \"/usr/bin/hdfs dfs -mkdir -p #{x}\"")
        should_mode = resource.should(:mode)
        unless self.mode == should_mode
            self.mode = should_mode
        end
        @property_hash[:ensure] = :present
    end

    def destroy
        x=resource[:name]
        system("su - hdfs -c \"/usr/bin/hdfs dfs -rm -f -r #{x}\"")
        @property_hash.clear
    end

    def exists?
        x=resource[:name]
        system("/usr/bin/hdfs dfs -test -e #{x} > /dev/null 2>&1")
    end
    def self.instances
        []
    end

    def mode
        if exists?
            `hdfs dfs -ls -d #{resource[:name]} | grep -v Found | \
            awk '{k = 0;
                for (g=2; g>=0; g--)
                    for (p=2; p>=0; p--) {
                        c = substr($1, 10 - (g * 3 + p), 1);
                        if (c ~ /[sS]/)
                            k += g * 02000;
                        else 
                            if (c ~ /[tT]/) 
                                k += 01000; 
                        if (c ~ /[rwxts]/) 
                            k += 8^g * 2^p
                    } 
            if (k) 
                printf("%03o ", k)}'`.strip
        else
            :absent
        end
    end

    def mode=(value)
        x=value.to_i
        y=resource[:name]
        system("su - hdfs -c \"/usr/bin/hdfs dfs -chmod #{x} #{y}\"")
    end
    # def self.instances
    #     entries = []
    #     str=`/usr/bin/hdfs dfs -ls / | grep -v Found`.split(/\r?\n/)
    #     puts "str #{str.size()}"
    #     str.each do |line|
    #         p=line.split(" ")[7]
    #         entries << new(:name => p)
    #     end
    #     puts "entries #{entries.size()}"
    #     entries
    # end

    # def self.prefetch(resources)
    #     puts "instances size #{instances.size()}"
    #     puts "resources size #{resources.size()}"
    #     instances.each do |prov|
    #         puts prov.name
    #         if resource = resources[prov.name]
    #             puts resource
    #             resource.provider = prov
    #         end
    #     end
    # end

#   def flush
#    create
#     @property_hash.clear
#   end

end
