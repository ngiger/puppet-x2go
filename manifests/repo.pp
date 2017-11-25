# Class: x2go::repo
# ===========================
#
# Authors
# -------
#
# Niklaus Giger <niklaus.giger@member.fsf.org>
# Lukas Kallies
#
# Copyright
# ---------
#
# Copyright 2016 Lukas Kallies
# Copyright 2011 Niklaus Giger

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class

# Supported distributions/version Debian, Ubuntu
# see http://wiki.x2go.org/doku.php/wiki:repositories:debian
#     http://wiki.x2go.org/doku.php/wiki:repositorîes:ubuntu
# see also about automatic login
#
class x2go::repo {

  case $::operatingsystem {
    'Debian': {
      include x2go::repo::debian
    }
    'Ubuntu': {
      include x2go::repo::ubuntu
    }
    'RedHat', 'CentOS', 'Fedora': {
      include x2go::repo::el
    }
    default: {
      fail("\nx2go not (yet?) supported under ${::operatingsystem}!!")
    }
  }
}

# kate: replace-tabs on; indent-width 2; indent-mode cstyle; syntax ruby
# vim: ts=2 et sw=2 autoindent
