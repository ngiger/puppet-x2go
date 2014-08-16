# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation
define x2go::server (
  $ensure             =  present,
) {
  include x2go::common

  package { ["x2goserver", "x2goserver-extensions", 'x2goserver-xsession'
    ]:
    ensure => $ensure,
    require => [ Class['x2go::common'], ],
    notify => Service['x2goserver'],
  }

  if ($ensure != absent) {
      $runService = running
      } else {
      $runService = stopped
    }
    
  service { 'x2goserver':
    ensure => $runService,
    enable => true,
    hasstatus => false,
    hasrestart => true,
    status => '/usr/bin/pgrep -f x2gocleansessions',
    require => [ Package ["x2goserver"] ] ,
  }
}
