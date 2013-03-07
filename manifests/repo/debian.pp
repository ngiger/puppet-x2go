class x2go::repo::debian {
  apt::source { 'x2go':
    location    => hiera('x2go::repo::debian:location', 'http://packages.x2go.org/debian'),
    release     => $lsbdistcodename,
    repos             => "main",
    key         => hiera('x2go::repo::debian:key', 'E1F958385BFE2B6E'),
    key_server        => "subkeys.pgp.net",
    include_src => false,
  }
}
