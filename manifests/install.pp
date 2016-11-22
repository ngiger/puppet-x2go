# Class x2go::install
class x2go::install (
) {
  class { '::x2go::repo': } ->
  class { '::x2go::client': } ->
  class { '::x2go::server': }
}
