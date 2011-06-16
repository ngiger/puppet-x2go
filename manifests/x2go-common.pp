# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 

class x2go::common {
  $x2go_dpkg_list =  "/etc/apt/sources.list.d/10_x2go.list"
  $x2go_key = "E1F958385BFE2B6E"
  # $x2go_key = "C509840B96F89133"
  file {$x2go_dpkg_list: ensure => present,
    owner   => root,
    content => "deb http://x2go.obviously-nice.de/deb/ lenny main\n",
    require => Exec['init_x2go_key']
  }

  exec { "init_x2go_key":
 command => "gpg --quiet --keyserver pgp.mit.edu --recv-keys $x2go_key ; gpg -a --export $x2go_key | sudo apt-key add -",
    path    => "/usr/bin:/usr/sbin:/bin:/sbin",
    unless  => "apt-key list | grep $x2go_key", 
    before => File[$x2go_dpkg_list],
  }	

  exec {'x2go_apt_update':
    command => "apt-get update",
    path    => "/usr/bin:/usr/sbin:/bin:/sbin",
    # refreshonly => true,
    require => File["${x2go_dpkg_list}"],
  }	

  package { "openssl":
    ensure => installed,
  }	
  package { "gnupg":
    ensure => installed,
  }	
}
