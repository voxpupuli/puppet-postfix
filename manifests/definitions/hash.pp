/*
== Definition: postfix::hash

Creates postfix hashed "map" files. It will create "${name}", and then build
"${name}.db" using the "postmap" command. The map file can then be referred to
using postfix::config.

Note: the content of the file is not managed by this definition.

Parameters:
- *name*: the name of the map file.
- *ensure*: present/absent, defaults to present

Requires:
- Class["postfix"]

Example usage:

  node "toto.example.com" {

    include postfix

    postfix::hash { "/etc/postfix/virtual":
      ensure => present,
    }
    postfix::config { "virtual_alias_maps":
      value => "hash:/etc/postfix/virtual"
    }
  }

*/
define postfix::hash ($ensure="present") {

  # selinux labels differ from one distribution to another
  case $operatingsystem {

    RedHat, CentOS: {
      case $lsbmajdistrelease {
        "4":     { $postfix_seltype = "etc_t" }
        "5":     { $postfix_seltype = "postfix_etc_t" }
        default: { $postfix_seltype = undef }
      }
    }

    default: {
      $postfix_seltype = undef
    }
  }

  file {"${name}":
    ensure => $ensure,
    mode   => 600,
    seltype => $postfix_seltype,
    require => Package["postfix"],
  }

  file {"${name}.db":
    ensure  => $ensure,
    mode    => 600,
    require => [File["${name}"], Exec["generate ${name}.db"]],
    seltype => $postfix_seltype,
  }

  exec {"generate ${name}.db":
    command => "postmap ${name}",
    #creates => "${name}.db", # this prevents postmap from being run !
    subscribe => File["${name}"],
    refreshonly => true,
    require => Package["postfix"],
  }
}
