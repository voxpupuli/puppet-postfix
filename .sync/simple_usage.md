This module requires Augeas.

## Simple usage

    include postfix

    postfix::config { "relay_domains": value  => "localhost host.foo.com" }

## Exec paths

In order to not have any path problem, you should add the following line in
some globally included .pp file:

    Exec {
      path => '/some/relevant/path:/some/other:...',
    }

For example:

    Exec {
      path => '/bin:/sbin:/usr/sbin:/usr/bin',
    }
