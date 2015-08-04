Puppet::Type.newtype(:hdfsfile) do
    @doc = "Manage a hdfs file (the simple version)."

    ensurable

    newparam(:name, :isnamevar => true) do
        desc "The full path to the file."
    end

    newproperty(:mode) do
        desc "Manage the file's mode."
        defaultto "777"
    end
end