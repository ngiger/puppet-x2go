class x2go::repo::el {
  File {
    owner => 'root',
    group => 'root',
    mode  => 0644,
  }
  file { '/etc/yum.repos.d/x2go.repo':
    content => template("${module_name}/x2go.repo"),
  }
  file { '/etc/yum/x2go-ci.org.key':
    content => template("${module_name}/x2go-ci.org.key"),
  }
  exec { 'rpm --import /etc/yum/x2go-ci.org.key':
    path    => '/bin:/usr/bin',
    require => File['/etc/yum/x2go-ci.org.key'],
    unless  => 'rpm -q gpg-pubkey-d50582e6-4a3feef6',
  }
}

