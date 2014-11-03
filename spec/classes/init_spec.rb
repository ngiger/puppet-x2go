require 'spec_helper'

describe 'x2go' do
  let(:facts) { WheezyFacts }

  context 'when running with default parameters' do
    it {
     should compile
     should compile.with_all_deps
     should contain_x2go
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
      should contain_class('X2go::Common')
      should contain_class('X2go::Repo::Debian')
      should contain_apt__key ('Add key: E1F958385BFE2B6E from Apt::Source x2go')
    }
  end
end
