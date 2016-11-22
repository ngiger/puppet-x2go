# x2go module for Puppet

This module provides classes to manage x2go client, server and thin client environment (aka tce).

You may choose to use either the baikal version (only bug-fixes) or the main.

## About this fork

This module has been forked from [ngiger/puppet-x2go](https://github.com/ngiger/puppet-x2go "ngiger/puppet-x2go") because 
[the original author switched to Saltstack](https://github.com/ngiger/puppet-x2go/pull/5#issuecomment-262303301 "PR 5, issuecomment").

## Examples

* To install the x2go client:

```
class { 'x2go':
  install_client => true,
}
```

This sets ensure => present for the package. If you want to set a different
value, you can override the x2go::params::ensure parameter using hiera.

* To remove the x2go client:

```
class { 'x2go':
  version => 'baikal',
}
class { 'x2go::client::absent': }
```
* To install the x2go server:

```
class { 'x2go':
  install_client => false,
  install_server => true,
}
```

* To install a x2go thin client environment

:red_circle: because the tce class needs a lot of dependencies which are not needed for x2go client/server classes the tce stuff is only in branch x2go-thinclient-environment_tce


```
class { 'x2go::tce':
  version          => 'latest',
  x2go_tce_base    => '/opt/x2gothinclient', # will have chroot and etc directories below
  export_2_network => '192.168.1.0/255.255.255.0',
}
```

You will probably have to customize your installation: see the [x2go wiki](http://wiki.x2go.org/doku.php/wiki:advanced:tce:install "x2go documentation: tce:install")

* see the files under test for more examples

## License

Copyright 2011-2013, niklaus.giger@member.fsf.org

This program is free software; you can redistribute  it and/or modify it under the terms of the GNU General Public License version 3 as published by
the Free Software Foundation.
