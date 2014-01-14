# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 
define x2go::client (
  $ensure             =  present,
) {
  include x2go::common
  
  package { "x2goclient":
    ensure => $ensure,
    require => Class['x2go::common','apt::update'],
  }	
}
