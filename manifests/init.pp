# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 
notify { "x2go/manifests/init.pp": }

class x2go($version = 'installed') {
  include x2go::repo
  class {
    'x2go::package':
      version => $version,
  }
  include x2go::service
  include x2go::firewall

  Class['x2go::repo'] -> Class['x2go::package']
  -> Class['x2go::service']
}
# vim: ts=2 et sw=2 autoindent

