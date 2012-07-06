# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation

class x2go::server   inherits x2go::common {
  package { ["x2goserver", 'x2goserver-xsession']:
   ensure => latest,
    require => Class['x2go::common'],
    notify => Service['x2goserver'],
  }

  service { 'x2goserver':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }
}
class {'x2go::server':stage => last; }
