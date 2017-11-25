# Class: x2go
# ===========================
#
# Parameters
# ----------
#
# * `version`
# Specify which repository version to use.
# e.g. baikal or main
#
# * `install_client`
# Boolean value to decide if the client should be installed.
#
# * `install_server`
# Boolean value to decide if the server should be installed.
#
# * `epel_repo`
# If this is running on an RedHat/Fedora based OS decide wheter to use
# use fedoraproject EPEL (fedora) or to use the x2go EPEL repository (x2go).
# Possible values:
# - fedora
# - x2go
#
# Examples
# --------
#
# @example
#    class { 'x2go::client': }
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
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.
#
class x2go(
  $version        = 'main',
  $install_client = true,
  $install_server = false,
  $epel_repo      = 'x2go',
) {
  class { '::x2go::install': } ~>
  class { '::x2go::service': }
}

# vim: ts=2 et sw=2 autoindent
