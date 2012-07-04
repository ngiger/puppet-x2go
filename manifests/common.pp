# kate: replace-tabs on; indent-width 2; indent-mode cstyle; syntax ruby
# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 

# Supported distributions/version Debian/squeeze Debian/wheezy Ubuntu/precise aka 12.04 LTS
# see http://wiki.x2go.org/doku.php/wiki:x2go-repository-debian
#     http://wiki.x2go.org/doku.php/wiki:x2go-repository-ubuntu # see also about automatic login
  notify { "x2go/manifests/common.pp $operatingsystem $operatingsystemrelease": }

class x2go::common {
  $x2go_dpkg_list =  "/etc/apt/sources.list.d/10_x2go.list"
  $x2go_key = "E1F958385BFE2B6E"

  case $operatingsystem {
      'Debian':  {
	  case $operatingsystemrelease {
	    'squeeze':  { $dist = 'squeeze' }
	    default:    { $dist = 'wheezy' }
	  }
	  file {"$x2go_dpkg_list":
            ensure => present,
	    owner   => root,
	    content => "deb http://packages.x2go.org/debian $dist main\n",
		# e.g.  deb http://packages.x2go.org/debian squeeze main
	    require => Exec['init_x2go_key'],
	    notify => Exec['x2go_apt_update'],
	  }
          notify { "x2go: Debian with $x2go_dpkg_list": }
	}
      'Ubuntu': {
	  package { "python-software-properties":
	    ensure => installed,
	  }
	exec {'x2go_add_ppa':
	  command => "add-apt-repository ppa:x2go/stable --yes",
	  path    => "/usr/bin:/usr/sbin:/bin:/sbin",
	  refreshonly => true,
	  unless => "grep x2go  /etc/apt/sources.list.d/*list",
	  require => Package["python-software-properties"],
          notify => Exec['x2go_apt_update'],
	}

      } # apply the redhat class
      default:  { fail("\nx2go not (yet?) supported under $operatingsystem!!")
          file {"$x2go_dpkg_list":
            ensure => present,
            owner   => root,
            content => "deb http://packages.x2go.org/debian $dist main\n",
                # e.g.  deb http://packages.x2go.org/debian squeeze main
            require => Exec['init_x2go_key'],
            notify => Exec['x2go_apt_update'],
          }
        
      }
    }

  exec { "init_x2go_key":
    command => "gpg --quiet --keyserver pgp.mit.edu --recv-keys $x2go_key ; gpg -a --export $x2go_key | sudo apt-key add -",
    path    => "/usr/bin:/usr/sbin:/bin:/sbin",
    unless  => "apt-key list | grep $x2go_key", 
    # before => File[$x2go_dpkg_list],
  }	

  exec {'x2go_apt_update':
    command => "apt-get update",
    path    => "/usr/bin:/usr/sbin:/bin:/sbin",
#    refreshonly => true,
  }	

  package { "openssl":
    ensure => installed,
  }	
  package { "gnupg":
    ensure => installed,
  }	
}
