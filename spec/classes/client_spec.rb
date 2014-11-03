require 'spec_helper'

describe 'x2go::client' do
  let(:facts) { WheezyFacts }
  let(:hiera_config) { }

  context 'when running with default parameters' do
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_x2go__client }
    it { should contain_package('x2goclient').with( { :ensure => 'false'  } ) }
  end

  context 'when running with ensure absent' do
    let(:params) { { :ensure => 'absent',}}
    it { should compile }
    it { should compile.with_all_deps }
    it { should_not contain_x2go }
    it { should contain_x2go__client }
    it { should contain_package('x2goclient').with( { :ensure => 'absent'  } ) }
  end

  context 'when running with ensure true' do
    let(:params) { { :ensure => 'true' } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_exec('apt_update') }
    it { should contain_class('X2go::Common') }
    it { should contain_class('X2go::Repo::Debian') }
    it { should contain_x2go__client }
    it { should contain_package('x2goclient') }
    it { should contain_apt__key ('Add key: E1F958385BFE2B6E from Apt::Source x2go') }
  end

end
