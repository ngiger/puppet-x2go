require 'spec_helper'

describe 'x2go::server' do
  let(:facts) { WheezyFacts }
  let(:hiera_config) { }

  context 'when running with default parameters' do
    it {
      should compile
      should compile.with_all_deps
      should contain_x2go__server
      should contain_package('x2goserver').with( { :ensure => 'absent'  } )
    }
  end

  context 'when running with ensure absent' do
    let(:params) { { :ensure => 'absent',}}
    it {
      should compile
      should compile.with_all_deps
      should_not contain_x2go
      should contain_x2go__server
      should contain_package('x2goserver').with( { :ensure => 'absent'  } )
    }
  end

  context 'when running with ensure true' do
    let(:params) { { :ensure => 'true' } }
    it {
      should compile
      should compile.with_all_deps
      should contain_exec('apt_update')
      should contain_class('X2go::Common')
      should contain_class('X2go::Repo::Debian')
      should contain_x2go__server
      # should contain_file('x2go.list').that_comes_before('Exec[apt_update]')
      should contain_exec('apt_update').that_comes_before('Package[x2goserver]')
      should contain_exec('apt_update').that_comes_before('Package[x2goserver-extensions]')
      should contain_exec('apt_update').that_comes_before('Package[x2goserver-xsession]')
      should contain_package('x2goserver-extensions')
      should contain_package('x2goserver').that_comes_before('Service[x2goserver]')
      should contain_apt__key ('Add key: E1F958385BFE2B6E from Apt::Source x2go')
    }
  end

end
