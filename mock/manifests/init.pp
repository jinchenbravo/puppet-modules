class mock{

notify{"Inside class mock": }

$hmhosts = query_nodes('node_type="hadoop_master"')
$hms=count($hmhosts)
#$hms=1
$hshosts = query_nodes('node_type="hadoop_slave"')
$hhosts = query_nodes('is_bigdataplatform="true"')

notify{"hadoop_master ${hmhosts}":}
notify{"hadoop_master_size ${hms}":}
notify{"hadoop_slave ${hshosts}":}
notify{"is_bdp ${hhosts}":}
if ( $hms == 2 ) {
 notify {"pgcluster has two master":
      loglevel => crit,
    }
}
# crit("this is crit. always visible")
# puppet node deactivate someoldnode.example.com
# puppet node clean someoldnode.example.com
}
