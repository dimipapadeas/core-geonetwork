class openwis::middleware::tomcat ()
{
  require openwis

  $tomcat_logs_dir  = "${openwis::logs_root_dir}/tomcat"

  #==============================================================================
  # Install Required packages
  #==============================================================================
  package { tomcat:
    ensure => latest,
  }

  #==============================================================================
  # Add the 'tomcat' user to the 'openwis' group
  #==============================================================================
  user { "tomcat":
    groups  => "openwis",
    shell   => "/sbin/nologin",
    require => [Package["tomcat"], Group["openwis"]]
  }

  #==============================================================================
  # Configure tomcat
  #==============================================================================
  # enable remote debug
  file_line { "tomcat.conf: enable remote debug":
    path    => "/etc/tomcat/tomcat.conf",
    line    => 'JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,address=8000,suspend=n"',
    notify  => Service[tomcat],
    require => Package[tomcat]
  }

  #==============================================================================
  # Configure logging
  #==============================================================================
  file { "${tomcat_logs_dir}":
    ensure  => directory,
  } ->
  file { "/usr/share/tomcat/logs":
    ensure  => link,
    target  => "${tomcat_logs_dir}",
    require => Package[tomcat],
    notify  => Service[tomcat]
  } ->
  file { "/var/log/tomcat":
    ensure  => link,
    target  => "${tomcat_logs_dir}",
    force   => true,
    require => Package[tomcat],
    notify  => Service[tomcat]
  }

  #==============================================================================
  # Enable & start services
  #==============================================================================
  service { tomcat:
    ensure  => running,
    enable  => true,
    require => Package[tomcat]
  }
}
