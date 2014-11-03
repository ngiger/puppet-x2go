require 'spec_helper'

describe 'x2go::tce' do
  let(:facts) { WheezyFacts.merge( { 'apt::proxy_host' => '192.1.2.3' } ) }
  let(:hiera_config) { }

  context 'when running with default parameters' do
    it {
      should compile
      should compile.with_all_deps
      should contain_x2go__tce
    }
#    it { should contain_package('x2goserver').with( { :ensure => 'false'  } ) }
  end

  context 'when running with ensure absent' do
    let(:params) { { :ensure => 'absent',}}
    it {
      should compile
      should compile.with_all_deps
      should_not contain_x2go
      should contain_x2go__tce
    }
#    it { should contain_package('x2goserver').with( { :ensure => 'absent'  } ) }
  end

  context 'when running with ensure true' do
    let(:params) { { :ensure => 'true' } }
    it {
      should compile
      should compile.with_all_deps
      should contain_exec('apt_update')
      should contain_class('X2go::Common')
      should contain_class('X2go::Repo::Debian')
      should contain_x2go__common
      should contain_x2go__tce
      should contain_package('x2goserver')
      should contain_package('x2goserver-extensions')
      should contain_package('x2goserver-xsession')
      should contain_package('x2gothinclientmanagement')
      should contain_apt__key ('Add key: E1F958385BFE2B6E from Apt::Source x2go')
      should contain_file('/opt/x2gothinclient/chroot/etc/default/keyboard').with_content(/^XKBMODEL='pc105'$/)
      should contain_file('/opt/x2gothinclient/chroot/etc/default/keyboard').with_content(/^XKBLAYOUT='ch'$/)
      should contain_file('/opt/x2gothinclient/chroot/etc/default/keyboard').with_content(/^XKBVARIANT=''$/)
      should contain_file('/opt/x2gothinclient/chroot/etc/default/keyboard').with_content(/^XKBOPTIONS=''$/)
      should contain_file('/opt/x2gothinclient/chroot/etc/default/keyboard').with_content(/^BACKSPACE='guess'$/)

      should contain_file('/etc/x2go/x2gothinclient_settings').with_content(/#.+Proxy set  by hiera apt::proxy_host and apt::proxy_port/)
      should contain_file('/etc/x2go/x2gothinclient_settings').with_content(/^TC_BASE="\/opt\/x2gothinclient"$/)

      should contain_file('/etc/x2go/x2gothinclient_start').with_content(/^x2goclient\s+--session='Standard'\s+--external-login=~x2gothinclient\/logins\s+--no-menu\s+--maximize\s+--thinclient\s+--haltbt\s+--link=lan\s+--kbd-layout=ch\s+--kbd-type=pc105\s+--set-kbd=1\s+--geometry=fullscreen\s+--read-exports-from=~x2gothinclient\/export\s+--session-edit\s+--add-to-known-hosts/)

      should contain_file('/opt/x2gothinclient/chroot/etc/default/locale').with_content(/^LANG=de_CH.utf-8$/)
      should contain_file('/opt/x2gothinclient/chroot/etc/default/locale').with_content(/^LANG=de_CH.utf-8$/)
      should contain_file('/opt/x2gothinclient/chroot/etc/default/locale').with_content(Managed_tce_regexp)

      first_match = /\[1\]
name ='X2go Elexis on server 172.25.1.70'
host = 172.25.1.70
command = \/usr\/local\/bin\/elexis
user = a_user
rdpserver = \# no RDP \(Windows only\)
applications = \[OFFICE, WWWBROWSER, MAILCLIENT, TERMINAL\]
/m
      second_match = /\[2\]
name ='Windows Client'
/
     should contain_file('/opt/x2gothinclient/etc/x2gothinclient_sessions').with_content(second_match)
     should contain_file('/opt/x2gothinclient/tftp/default.cfg').with_content(/^include x2go-elexis-tce.cfg$/)
     should contain_file('/opt/x2gothinclient/tftp/x2go-elexis-tce.cfg').with_content(/^\s*LABEL x2go-elexis-tce$/)
     should contain_file('/opt/x2gothinclient/tftp/x2go-elexis-tce.cfg').with_content(/^\s*MENU LABEL  X2Go \^Elexis Thin Client$/)
     should contain_file('/opt/x2gothinclient/tftp/x2go-elexis-tce.cfg').with_content(/^\s*KERNEL vmlinuz.486$/)
     should contain_file('/opt/x2gothinclient/tftp/x2go-elexis-tce.cfg').with_content(/^\s*APPEND initrd=initrd.img.486 nfsroot=\/opt\/x2gothinclient\/chroot boot=nfs ro nomodeset splash$/)

     should contain_file('/usr/local/bin/x2gothinclient_add_firmware').with_content(/x2gothinclient_shell "echo 'deb http:\/\/ftp.debian.org\/debian  wheezy contrib non-free' > \/etc\/apt\/sources.list.d\/wheezy_non-free.list/)
     should contain_file('/usr/local/bin/x2gothinclient_add_firmware').with_content(/x2gothinclient_shell "apt-get update"/)
     should contain_file('/usr/local/bin/x2gothinclient_add_firmware').with_content(/x2gothinclient_shell "apt-get install --yes locales-all firmware-linux firmware-linux-nonfree firmware-bnx2 firmware-bnx2x/)

     should contain_nfs__export('/opt/x2gothinclient/chroot')
     should contain_exec('x2go::tce::x2gothinclient_create')
     should contain_exec('x2go::tce::x2gothinclient_preptftpboot')
     should contain_exec('x2go::tce::x2gothinclient_update')
     should contain_service('dnsmasq')
     should contain_service('nfs-kernel-server')
     should contain_service('portmap')
     should contain_service('x2goserver')
     should contain_sshd_config('AllowGroups')
  }

  end

end
