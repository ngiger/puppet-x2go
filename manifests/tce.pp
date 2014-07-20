# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 
# Inspired by description found under http://wiki.x2go.org/doku.php/wiki:advanced:tce:install

# sudo debootstrap --variant=minbase --arch=ARCHITEKTUR CODENAME /mnt http://de.archive.ubuntu.com/ubuntu/ 
# x2go::tce::x2go_tce_base


class x2go::tce (
  $ensure             =  latest,
  $export_2_network   = '172.27.0.0/16',
  $server             = '172.27.1.77',
  $x2go_tce_base      = '/opt/x2gothinclient',
  $x2go_tce_os        = 'wheezy',
  $x2go_tce_mirror    = 'http://ftp.debian.org/debian',
  $pxe_service        = "X86PC, 'Boot thinclient from network (x2go)', /pxelinux, $server",
  $boot_params        = "ltsp/i386/pxelinux.0,server,$server",
  $x2go_server        = '172.25.1.70',
  $window_manager     = 'KDE',
) {
  include x2go::common
  $x2go_chroot        = "$x2go_tce_base/chroot"
#  $mount_point        = '/srv/exports/tce.schoebu'
  $mount_point        = $x2go_chroot

  class {'dnsmasq::x2go_tce':
    log_dhcp      => true,
    pxe_service   => $pxe_service,
    boot_params   => $boot_params,
    x2go_tce_root => $x2go_tce_base,
    tftp_root     => "$x2go_tce_base/tftp",
  }

  notify { "Using x2go_tce_base WITH $x2go_tce_base and chroot $x2go_chroot for $x2go_tce_os":}
  package { 'x2gothinclientmanagement':
    ensure => $ensure,
    require => Class['x2go::common','apt::update'],
  }
  
  file {'/etc/x2go/x2gothinclient_settings':
    require => Class['x2go::common','apt::update'],
    content => template("x2go/x2gothinclient_settings.erb"),
    notify  => Exec['x2go::tce::x2gothinclient_update'],
    }

  file {"$x2go_tce_base/tftp/x2go-elexis-tce.cfg":
    content => "LABEL x2go-elexis-tce
        MENU LABEL  X2Go ^Elexis Thin Client
        MENU DEFAULT
        KERNEL vmlinuz.486
        APPEND initrd=initrd.img.486 nfsroot=$mount_point boot=nfs ro nomodeset splash
    ",
    require => Exec['x2go::tce::x2gothinclient_preptftpboot'],
    notify  => Exec['x2go::tce::x2gothinclient_update'],
    }

    if (false) {

  file {"$x2go_tce_base/etc/x2gothinclient_sessions":
    require => Exec['x2go::tce::x2gothinclient_preptftpboot'],
    notify  => Exec['x2go::tce::x2gothinclient_update'],
    content => "[20100623163928371]
defsndport = false
useiconv = false
iconvfrom = ISO8859-15
height = 768
export = 
speed = 4
fullscreen = true
layout = us
width = 1024
quality = 9
xdmcpserver = localhost
soundtunnel = 1
rdpoptions = 
soundsystem = pulse
print = 1
type = pc105/us
sndport = 4713
usekbd = true
fstunnel = true
applications = OFFICE, WWWBROWSER, MAILCLIENT, TERMINAL
host = $x2go_server
link = ADSL
user = vagrant
key = 
startsoundsystem = false
icon =
sound = true
rootless = false
name = X2go Elexis $x2go_server
iconvto = UTF-8
rdpserver = 
useexports = true
command = $window_manager
dpi = 96
sshport = 22
setdpi = false
pack = 16m-jpeg
",
    }
  } else {
    $sessions = hiera('x2go::tce::sessions',[])
    file {"$x2go_tce_base/etc/x2gothinclient_sessions":
      require => Exec['x2go::tce::x2gothinclient_preptftpboot'],
      notify  => Exec['x2go::tce::x2gothinclient_update'],
      content => template("x2go/x2gothinclient_sessions.erb"),
    }
  }
  file {"$x2go_tce_base/tftp/default.cfg":
    require => Exec['x2go::tce::x2gothinclient_preptftpboot'],
    content => "
#
# example for a main boot menu of an X2Go Thin Client
#

DEFAULT vesamenu.c32
PROMPT 0
MENU BACKGROUND x2go-splash.png
MENU TITLE Elexis X2Go Thin Client Environment

include local-boot.cfg
include x2go-elexis-tce.cfg
MENU SEPARATOR
include memtest.cfg

# menu settings
MENU VSHIFT 3
MENU HSHIFT 18
MENU WIDTH 60
MENU MARGIN 10
MENU ROWS 12
MENU TABMSGROW 13
MENU CMDLINEROW 23
MENU ENDROW 12
MENU TIMEOUTROW 18

MENU COLOR border       30;44      #40ffffff #a0000000 std
MENU COLOR title        1;36;44    #9033ccff #a0000000 std
MENU COLOR sel          7;37;40    #e0000000 #20ffffff all
MENU COLOR unsel        37;44      #50ffffff #a0000000 std
MENU COLOR help         37;40      #c0ffffff #a0000000 std
MENU COLOR timeout_msg  37;40      #80ffffff #00000000 std
MENU COLOR timeout      1;37;40    #c0ffffff #00000000 std
MENU COLOR msg07        37;40      #90ffffff #a0000000 std
MENU COLOR tabmsg       37;40      #e0ffffff #a0000000 std
MENU COLOR disabled     37;44      #50ffffff #a0000000 std
MENU COLOR hotkey       1;30;47    #ffff0000 #a0000000 std
MENU COLOR hotsel       1;7;30;47  #ffff0000 #20ffffff all
MENU COLOR scrollbar    30;47      #ffff0000 #00000000 std
MENU COLOR cmdmark      1;36;47    #e0ff0000 #00000000 std
MENU COLOR cmdline      30;47      #ff000000 #00000000 none

# possible boot profiles for ONTIMEOUT: 
# localboot, x2go-tce-686, x2go-tce-486
# (... or any other profile you defined in your customized menu)
ONTIMEOUT x2go-elexis-tce
TIMEOUT 50
"
}


  exec{'x2go::tce::x2gothinclient_create':
    require => [
      Package['x2gothinclientmanagement'],
      File['/etc/x2go/x2gothinclient_settings'],
      ],
      # we install also the default configuration
    command => "rm -rf $x2go_chroot; sudo -iuroot x2gothinclient_create",
    path => '/usr/local/bin:/usr/bin/:/bin:/usr/sbin:/sbin',
    creates => "$x2go_chroot/etc/apt/sources.list.d/x2go.list",
    notify  => Exec['/usr/local/bin/x2gothinclient_add_firmware'],
    timeout => 1800, # allow maximal 30 minutes for download all the stuff. Default timeout is too short
  }

  file{'/usr/local/bin/x2gothinclient_add_firmware':
    require => [Exec['x2go::tce::x2gothinclient_create']],
    content => template("x2go/x2go_install_firmware.erb"),
    notify  => Exec['/usr/local/bin/x2gothinclient_add_firmware'],
    mode => 0755,
  }
  exec{'/usr/local/bin/x2gothinclient_add_firmware':
    command => "/usr/local/bin/x2gothinclient_add_firmware",
    path => '/usr/local/bin:/usr/bin/:/bin:/usr/sbin:/sbin',
    notify  => Exec['x2go::tce::x2gothinclient_update'],
  }

  exec{'x2go::tce::x2gothinclient_update':
    require => [
      Package['x2gothinclientmanagement'],
      File['/etc/x2go/x2gothinclient_settings'],
      ],
      # we install also the default configuration
    command => "sudo -iuroot x2gothinclient_update",
    path => '/usr/local/bin:/usr/bin/:/bin:/usr/sbin:/sbin',
    notify => Service['dnsmasq'],
  }
  exec{'x2go::tce::x2gothinclient_preptftpboot':
    require => Exec['x2go::tce::x2gothinclient_create'],
    command => "rm -rf $x2go_tce_base/tftp; sudo -iuroot x2gothinclient_preptftpboot", # we need to use sudo or x2go will complain!
    path => '/usr/local/bin:/usr/bin/:/bin:/usr/sbin:/sbin',
    creates => "$x2go_tftp_root/x2go-splash.png",
    }
    
class { 'nfs::server':
    package => latest,
    service => running,
    enable  => true,
}

nfs::export { "$x2go_chroot":
        options => [ 'ro', 'async', 'no_subtree_check', 'no_root_squash'],
        clients => [ "$export_2_network" ],
    }
}

