Package {
	allow_virtual => false,
}

# ensure that the old provisioning working folders are removed
file {["/vagrant/provisioning/config",
       "/vagrant/provisioning/downloads",
			 "/vagrant/provisioning/scripts",
			 "/vagrant/provisioning/working"]:
	ensure => absent,
	force => true
}

# configure 'vagrant' user's 'bin' folder & shell script links
file {"/home/vagrant/bin":
  ensure => directory,
  owner  => "vagrant",
  group  => "vagrant",
} ->
link_script { "initialise-db":
} ->
link_script { "configure-jboss":
} ->
link_script { "deploy-dataservices":
} ->
link_script { "deploy-managementservices":
} ->
link_script { "deploy-portal":
}

# configure the host files, so that the boxes can see each other
host { "ow4dev-db":
	ensure => present,
	ip     => "192.168.54.101"
}
host { "ow4dev-data":
	ensure => present,
	ip     => "192.168.54.102"
}
host { "ow4dev-portal":
	ensure => present,
	ip     => "192.168.54.103"
}

# clear logs & re-start services
clear_logs { "jboss-as":
	logs_folders => ["/home/openwis/logs/jboss", "/home/openwis/logs/openwis"]
} ->
clear_logs { "tomcat":
	logs_folders => ["/home/openwis/logs/tomcat"]
}

#===============================================================================
define link_script ()
{
	file {"/home/vagrant/bin/${name}":
    ensure => link,
    target => "/tmp/provisioning/scripts/${name}.sh"
	}
}

#===============================================================================
define clear_logs (
	$logs_folders = []
)
{
	exec { "stop service ${name}":
		command => "systemctl stop ${name}",
		onlyif  => "systemctl is-enabled ${name}",
		user    => "root",
		path    => $::path
	}

	$logs_folders.each |String $logs_folder| {
		exec { "clear ${logs_folder}":
			command => "rm -rf ${logs_folder}/*",
			onlyif  => "test -d ${logs_folder}",
			user    => "root",
			path    => $::path,
			require => Exec["stop service ${name}"],
			before  => Exec["start service ${name}"]
		}
	}

	exec { "start service ${name}":
		command => "systemctl start ${name}",
		onlyif  => "systemctl is-enabled ${name}",
		user    => "root",
		path    => $::path
	}
}
