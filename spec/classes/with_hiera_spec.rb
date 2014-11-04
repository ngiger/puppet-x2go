require 'spec_helper'
RSpec.configure do |c|
  c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
end

describe 'x2go' do
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml to set configuration values' do
    let(:params) { { } }
    let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
    it {
      should compile
      should compile.with_all_deps
      should contain_exec('apt_update')
      should contain_class('X2go::Common')
      should contain_class('X2go::Repo::Debian')
      should contain_apt__key ('Add key: E1F958385BFE2B6E from Apt::Source x2go')
  }
  end
end

describe 'x2go::client' do
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml to set configuration values' do
    let(:params) { { } }
    let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
    it {
      should compile
      should compile.with_all_deps
      should contain_exec('apt_update')
      should contain_class('X2go::Client')
      should contain_class('X2go::Common')
      should contain_class('X2go::Repo::Debian')
      should contain_apt__key('Add key: E1F958385BFE2B6E from Apt::Source x2go')
      should contain_package('x2goclient')
      should_not contain_package('x2goserver')
    }
  end
end

describe 'x2go::server' do
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml to set configuration values' do
    let(:params) { { } }
    let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
    it {
      should compile
      should compile.with_all_deps
      should contain_exec('apt_update')
      should contain_class('X2go::Server')
      should contain_class('X2go::Common')
      should contain_class('X2go::Repo::Debian')
      should contain_apt__key('Add key: E1F958385BFE2B6E from Apt::Source x2go')
      should contain_package('x2goserver')
      should contain_package('x2goserver-extensions')
      should contain_package('x2goserver-xsession')
      should_not contain_package('x2goclient')
      should contain_service('x2goserver').with( { :ensure => 'running' } )
    }
  end
end

describe 'x2go::tce' do
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml to set configuration values' do
    let(:params) { { } }
    let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
    it {
      should compile
      should compile.with_all_deps
      should contain_exec('apt_update')
      should contain_class('X2go::Tce')
      should contain_class('X2go::Server')
      should contain_class('X2go::Common')
      should contain_class('X2go::Repo::Debian')
      should contain_apt__key('Add key: E1F958385BFE2B6E from Apt::Source x2go')
      should contain_package('x2goserver')
      should contain_package('x2goserver-extensions')
      should contain_package('x2goserver-xsession')
      should_not contain_package('x2goclient')
      should contain_service('x2goserver').with( { :ensure => 'running' } )
      should contain_file('/opt_mustermann/x2gothinclient/chroot/etc/default/keyboard').with_content(/^XKBMODEL='pc104'$/)
      should contain_file('/opt_mustermann/x2gothinclient/chroot/etc/default/keyboard').with_content(/^XKBLAYOUT='de'$/)
      should contain_file('/opt_mustermann/x2gothinclient/chroot/etc/default/keyboard').with_content(/^XKBVARIANT=''$/)
      should contain_file('/opt_mustermann/x2gothinclient/chroot/etc/default/keyboard').with_content(/^XKBOPTIONS=''$/)
      should contain_file('/opt_mustermann/x2gothinclient/chroot/etc/default/keyboard').with_content(/^BACKSPACE='guess'$/)

      should contain_file('/etc/x2go/x2gothinclient_settings').with_content(HIERA_HINT)
      should contain_file('/etc/x2go/x2gothinclient_settings').with_content(/^TC_BASE="\/opt_mustermann\/x2gothinclient"$/)

      should contain_file('/etc/x2go/x2gothinclient_start').with_content(/^x2goclient\s+--session='Standard'\s+--external-login=~x2gothinclient\/logins\s+--no-menu\s+--maximize\s+--thinclient\s+--haltbt\s+--link=lan\s+--kbd-layout=de\s+--kbd-type=pc104\s+--set-kbd=1\s+--geometry=fullscreen\s+--read-exports-from=~x2gothinclient\/export\s+--session-edit\s+--add-to-known-hosts/)

      should contain_file('/opt_mustermann/x2gothinclient/chroot/etc/default/locale').with_content(/^LANG=de_DE.utf-8$/)
      should contain_file('/opt_mustermann/x2gothinclient/chroot/etc/default/locale').with_content(/^LANGUAGE=de_DE:de$/)
      should contain_file('/opt_mustermann/x2gothinclient/chroot/etc/default/locale').with_content(Managed_tce_regexp)

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
      should contain_file('/opt_mustermann/x2gothinclient/etc/x2gothinclient_sessions').with_content(second_match)
      should contain_file('/opt_mustermann/x2gothinclient/tftp/default.cfg').with_content(/^include x2go-elexis-tce.cfg$/)
      should contain_file('/opt_mustermann/x2gothinclient/tftp/x2go-elexis-tce.cfg').with_content(/^\s*LABEL x2go-elexis-tce$/)
      should contain_file('/opt_mustermann/x2gothinclient/tftp/x2go-elexis-tce.cfg').with_content(/^\s*MENU LABEL  X2Go \^Elexis Thin Client$/)
      should contain_file('/opt_mustermann/x2gothinclient/tftp/x2go-elexis-tce.cfg').with_content(/^\s*KERNEL vmlinuz.486$/)
      should contain_file('/opt_mustermann/x2gothinclient/tftp/x2go-elexis-tce.cfg').with_content(/^\s*APPEND initrd=initrd.img.486 nfsroot=\/opt_mustermann\/x2gothinclient\/chroot boot=nfs ro nomodeset splash$/)

      should contain_file('/usr/local/bin/x2gothinclient_add_firmware').with_content(/x2gothinclient_shell "echo 'deb http:\/\/ftp.mustermann.debian.org\/debian\s+jessie\s+contrib non-free' > \/etc\/apt\/sources.list.d\/jessie_non-free.list/)
      should contain_file('/usr/local/bin/x2gothinclient_add_firmware').with_content(/x2gothinclient_shell "apt-get update"/)
      should contain_file('/usr/local/bin/x2gothinclient_add_firmware').with_content(/x2gothinclient_shell "apt-get install --yes locales-all firmware-linux firmware-linux-nonfree firmware-bnx2 firmware-bnx2x/)
    }
  end
end
