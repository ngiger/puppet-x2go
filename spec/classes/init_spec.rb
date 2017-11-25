require 'spec_helper'

describe 'x2go' do
  let(:facts) do
    {
      :operatingsystem => 'Debian',
	  :osfamily        => 'Debian',
	  :puppetversion   => Puppet.version,
	  :lsbdistid       => 'Debian',
	  :lsbdistcodename => 'wheezy',
    }
  end

  context 'when running with version installed' do
    let(:params) { { :version => 'installed',}}
    it {
      should compile
      should compile.with_all_deps
      should create_class('x2go')
    }
  end

  context 'when running with version latest' do
    let(:params) { { :version => 'latest' } }
    it {
      should compile
      should compile.with_all_deps
      should contain_exec('apt_update')
      should contain_class('X2go::Client')
      should contain_class('X2go::Repo')
      should contain_class('X2go::Repo::Debian')
      should contain_apt__key ('Add key: E1F958385BFE2B6E from Apt::Source x2go')
    }
  end
  context 'with defaults for all parameters' do
    it { should contain_class('x2go') }
  end
end
