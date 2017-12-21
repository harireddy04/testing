class telnet inherits telnet::params{

$package  = $telnet::params::package_name
$service  = $telnet::params::service_name


exec { "yum-update":
  command  => "/usr/bin/yum update -y",
}

package { "$package":
  ensure  =>  "installed",
  require  => Exec["yum-update"],
}

service { "$service":
  ensure  => "running",
  enable  => "true",
  require  => Package["$package"],
}

file { "/etc/xinetd.d/telnet":
  ensure  => "present",
# content  =>  "this is the telnet my own configuration file",
content  => template("telnet/telnet.erb"),
  notify  => Service["$service"],
}
}
