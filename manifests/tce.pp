# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 
# Inspired by description found under http://wiki.x2go.org/doku.php/wiki:advanced:tce:install

define x2go::tce (
  $ensure             =  latest,
  $export_2_network = '172.25.0.0/255.255.0.0',
  $x2go_chroot = '/opt/x2gothinclient/chroot',  
) {
  include x2go::common
  
  package { 'x2gothinclientmanagement':
    ensure => $ensure,
    require => Class['x2go::common','apt::update'],
  }
  
  file {'/etc/x2go/x2gothinclient_settings':
    content => template("x2go/x2gothinclient_settings.erb"),
    }

  exec{'x2go::tce::x2gothinclient_create':
    require => [
      Package['x2gothinclientmanagement'],
      File['/etc/x2go/x2gothinclient_settings'],
      ],
      # we install also the default configuration
    command => "rm -rf $x2go_chroot && sudo -iuroot x2gothinclient_create && sudo -iuroot x2gothinclient_update",
    path => '/usr/local/bin:/usr/bin/:/bin:/usr/sbin:/sbin',
    creates => "$x2go_chroot/etc/apt/sources.list.d/x2go.list",
  }
  exec{'x2go::tce::x2gothinclient_preptftpboot':
    require => Exec['x2go::tce::x2gothinclient_create'],
    command => 'sudo -iuroot x2gothinclient_preptftpboot', # we need to use sudo or x2go will complain!
    path => '/usr/local/bin:/usr/bin/:/bin:/usr/sbin:/sbin',
    creates => '/srv/tftp/x2go-splash.png'
    }
    
  file{'/etc/exports.old':
    content => "$x2go_chroot  172.25.0.0/255.255.0.0(ro,async,no_root_squash,no_subtree_check)
",
    require => Exec['x2go::tce::x2gothinclient_preptftpboot'],
  }
  
  augeas{ "export tce chroot" :
    context => "/files/etc/exports",
    changes => [
        "set dir[last()+1] '$x2go_chroot'",
        "set dir[last()]/client $export_2_network",
        "set dir[last()]/client/option[1] ro",
        "set dir[last()]/client/option[2] async",
        "set dir[last()]/client/option[3] no_root_squash",
        "set dir[last()]/client/option[4] no_subtree_check",
    ],
    onlyif => "match dir[. = '$x2go_chroot'] size == 0",
  }
}

