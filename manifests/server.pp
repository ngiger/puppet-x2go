# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation

class x2go::server   inherits x2go::common {
  package { "x2goserver":
    ensure => installed,
#    require => [ Package[openssl,gnupg], Exec["x2go_apt_update"] ]
  }
}
