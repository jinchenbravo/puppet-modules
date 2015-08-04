require 'facter'

Facter.add("postgresql_standby") do

    confine :is_bigdataplatform => 'true'
    confine :node_type => 'hadoop_master'
    setcode do 
        'false'
    end
    h=`hostname -s`.chomp
    pst=`ps -ef | grep "postgres: wal receiver process" | grep -v root`.split(/\r?\n/)
    if system('id postgres > /dev/null 2>&1')
        rst=`su - postgres -c "repmgr -f /etc/repmgr/repmgr.WARNING.conf cluster show"`.split(/\r?\n/)
        c=rst.select{|x| x =~ /^  standby.*#{h}/}
        if rst.size() == 4 && pst.size() == 1 && c.size() == 1
            c[0].scan(/host=(.*) dbname/) do |rh|
                if rh[0].chomp == h
                    setcode do
                       'true'
                    end
                end
            end
        end
    end
end



Facter.add("postgresql_master") do

    confine :is_bigdataplatform => 'true'
    confine :node_type => 'hadoop_master'
    setcode do 
        'false'
    end    
    h=`hostname -s`.chomp
    pst=`ps -ef | grep "postgres: wal sender process" | grep -v root`.split(/\r?\n/)
    if system('id postgres > /dev/null 2>&1')
        rst=`su - postgres -c "repmgr -f /etc/repmgr/repmgr.WARNING.conf cluster show"`.split(/\r?\n/)
        c=rst.select{|x| x =~ /^\* master.*#{h}/}
        if rst.size() == 4 && pst.size() == 1 && c.size() == 1
            c[0].scan(/host=(.*) dbname/) do |rh|
                if rh[0].chomp == h
                    setcode do
                       'true'
                    end
                end
            end
        end
    end
end




