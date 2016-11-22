# Class x2go::repo::debian
class x2go::repo::debian {
  case $x2go::version {
    'baikal': { $release_train = 'baikal'  }
    default:  { $release_train = 'main' }
  }

  # puppetlabs/apt
  # By default, Puppet runs apt-get update on the first Puppet run after you
  # include the apt class, and anytime notify => Exec['apt_update']
  class { 'apt': }
  apt::source { 'x2go':
    location    => 'http://packages.x2go.org/debian',
    release     => $::lsbdistcodename,
    repos       => $release_train,
    include_src => false,
    key         => {
      'id'     => 'E1F958385BFE2B6E',
      'server' => 'pgp.mit.edu',
    },
  }
}
