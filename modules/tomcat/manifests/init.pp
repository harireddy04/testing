class tomcat inherits tomcat::params{
$java_pkg  = "$tomcat::params::java_pkg"  
$gname     = "$tomcat::params::tomcat_gname"
$uname     =  "$tomcat::params::tomcat_uname"


exec { 'yum-update':
  command  =>  "/usr/bin/yum update -y",
}

package {"$java_pkg":
  ensure  => "present",
}

group { "$gname":
  ensure  => "present",
  gid     => "2001",
}

user {"$uname":
  ensure  => "present",
  comment => "Tomcat Admin",
  uid     => "2002",
  gid     => "2001",
  home    => "/opt/tomcat", 
  shell   => "/bin/bash", 
  require => [Group["$gname"]],
  before  => File["/opt/tomcat"],
}


file { "/opt/tomcat":
  ensure  => "directory",
  mode    => "755",
  owner   => "tomcat",
  group   => "tomcat",
#  require => [User["tomcat"],Group["tomcat"]],
}

exec { "downloading tomcat":
  command  => "/usr/bin/wget http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz",
  cwd      => "/opt/tomcat",
  unless    => "/usr/bin/test -f /opt/tomcat/apache-tomcat-8.5.24.tar.gz",
  require  =>  User["$uname"],
} 

exec { "extracting tomcat":
  command  => "/bin/tar -xzf /opt/tomcat/apache-tomcat-8.5.24.tar.gz", 
  cwd      => "/opt/tomcat",
  unless   => "/usr/bin/test -f /opt/tomcat/apache-tomcat-8.5.24",   
  require  => Exec["downloading tomcat"],
} 

exec {"starting the tomcat":
  command  => "/bin/sh /opt/tomcat/apache-tomcat-8.5.24/bin/startup.sh",
}

}

