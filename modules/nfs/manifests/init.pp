class nfs inherits nfs::params {
$servers  = ["192.168.56.101", "192.168.56.102", "192.168.56.103", "192.168.56.104"]

$server1  = "192.168.56.105"
$server2  = "192.168.56.102"
$server3  = "192.168.56.103"
$server4  = "192.168.56.104"
$package  = $nfs::params::package_name
$service  = $nfs::params::service_name

exec { 'yum-update':
  command  => '/usr/bin/yum update -y'
}

package {$package:
  ensure  =>  installed,
  require => Exec["yum-update"],
}


service {$service:
  ensure  => 'running',
  enable  => 'true',
  require => Package[$package],
}


file {"/etc/exports":
  ensure  => "present",
#  source  => "puppet:///modules/nfs/exports",
#  content => "/nfsshare 192.168.0.101(rw,sync,no_root_squash)",
  content  => template("nfs/exports.erb"),
  notify  => Service[$service],
 } 



}

