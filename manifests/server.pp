# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation
class x2go::server (
  $ensure             =  false,
) {
  include x2go::common


  if ($ensure) {
      ensure_packages(["x2goserver", "x2goserver-extensions", 'x2goserver-xsession'],
                      { ensure => $ensure,
                        require => [ Class['x2go::common'], Exec['apt_update'], ],
#                        subscribe => Exec['apt_update'] ,
                      }
                     )
      $runService = running
      service { 'x2goserver':
        ensure => $runService,
        enable => true,
        hasstatus => false,
        hasrestart => true,
        status => '/usr/bin/pgrep -f x2gocleansessions',
        require => [ Package ["x2goserver"] ] ,
      }
    } else {
      $runService = stopped
      ensure_packages(["x2goserver", "x2goserver-extensions", 'x2goserver-xsession'], { ensure => absent, })
      service { 'x2goserver': ensure => stopped, }
    }

}
