# Class x2go::repo::ubuntu
class x2go::repo::ubuntu {

  # puppetlabs/apt
  # By default, Puppet runs apt-get update on the first Puppet run after you
  # include the apt class, and anytime notify => Exec['apt_update']
  class { 'apt': }
  apt::source { 'x2go':
    location    => 'http://ppa.launchpad.net/x2go/stable/ubuntu',
    repos       => 'main',
    include_src => false,
    key         => {
      'id'     => 'a7d8d681b1c07fe41499323d7cde3a860a53f9fd',
      'server' => 'pgp.mit.edu',
    },
  }

}
