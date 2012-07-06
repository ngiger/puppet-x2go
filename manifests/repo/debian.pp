class x2go::repo::debian {
  apt::source { 'x2go':
    location    => 'http://pkg.x2go-ci.org/debian',
    release     => $lsbdistcodename,
    repos       => 'binary/',
    key         => 'D50582E6',
    key_source  => 'http://pkg.x2go-ci.org/debian/x2go-ci.org.key',
    include_src => false,
  }
}
