# kate: replace-tabs on; indent-width 2; indent-mode cstyle; syntax ruby
# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 

# Supported distributions/version Debian/squeeze Debian/wheezy Ubuntu/precise aka 12.04 LTS
# see http://wiki.x2go.org/doku.php/wiki:x2go-repository-debian
#     http://wiki.x2go.org/doku.php/wiki:x2go-repository-ubuntu # see also about automatic login
class x2go::common() {
  case $operatingsystem {
      'Debian':  {
          include apt
          include x2go::repo::debian
	}
  'Ubuntu': {
      include apt
      apt::ppa { "ppa:x2go/stable": }
  } # apply the redhat class
  default:  { fail("\nx2go not (yet?) supported under $operatingsystem!!")
      }       
  }
}
