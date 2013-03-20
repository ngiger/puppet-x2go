class x2go::repo::debian {
  apt::source { 'x2go':
    location    => 'http://packages.x2go.org/debian',
    release     => $lsbdistcodename,
    repos             => "main",
    key         => 'E1F958385BFE2B6E',
    key_server        => "subkeys.pgp.net",
    include_src => false,
  }
}
