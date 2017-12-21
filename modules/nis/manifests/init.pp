class nis {

exec { 'yum-update':
  command  =>  "/usr/bin/yum update -y",
}

package {'ypserv':
  ensure  => "installed",
  require => Exec["yum-update"],
}

service { 'ypserv':
  ensure  => "running",
  enable  => "true",
  require => Package["ypserv"],
}  


file { '/etc/sysconfig/network':
  ensure  => "present",
  source  => "puppet:///modules/nis/network",
  require => Service["ypserv"],
}


}

