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

  include apt
  apt::key { "x2go":
    key        => $x2go_key,
    key_server => "keys.gnupg.net ",
  }
  
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
	  }
          notify { "x2go: Debian with $x2go_dpkg_list": }
	}
      'Ubuntu': {
	  package { "python-software-properties":
	    ensure => installed,
	  }
          apt::ppa { " ppa:x2go/stable": }

      } # apply the redhat class
      default:  { fail("\nx2go not (yet?) supported under $operatingsystem!!")
          file {"$x2go_dpkg_list":
            ensure => present,
            owner   => root,
            content => "deb http://packages.x2go.org/debian $dist main\n",
          }
        
      }
    }
}
class {'x2go::common':stage => first; }
