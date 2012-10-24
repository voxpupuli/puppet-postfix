#== Definition: postfix::virtual
#
#Manages content of the /etc/postfix/virtual map.
#
#Parameters:
#- *name*: name of address postfix will lookup. See virtual(8).
#- *destination*: where the emails will be delivered to. See virtual(8).
#- *ensure*: present/absent, defaults to present.
#
#Requires:
#- Class["postfix"]
#- Postfix::Hash["/etc/postfix/virtual"]
#- Postfix::Config["virtual_alias_maps"]
#- augeas
#
#Example usage:
#
#  node "toto.example.com" {
#
#    include postfix
#
#    postfix::hash { "/etc/postfix/virtual":
#      ensure => present,
#    }
#    postfix::config { "virtual_alias_maps":
#      value => "hash:/etc/postfix/virtual"
#    }
#    postfix::virtual { "user@example.com":
#      ensure      => present,
#      destination => "root",
#    }
#  }
#
define postfix::virtual (
  $destination,
  $nexthop='',
  $file='/etc/postfix/virtual',
  $ensure='present'
) {
  include postfix::augeas

  case $ensure {
    'present': {
      $changes = [
        "set pattern[. = '${name}'] '${name}'",
        # TODO: support more than one destination
        "set pattern[. = '${name}']/destination '${destination}'",
      ]
    }

    'absent': {
      $changes = "rm pattern[. = '${name}']"
    }

    default: {
      fail("Wrong ensure value: ${ensure}")
    }
  }

  augeas {"Postfix virtual - ${name}":
    incl    => $file,
    lens    => 'Postfix_Virtual.lns',
    changes => $changes,
    require => [Package['postfix'], Augeas::Lens['postfix_transport']],
    notify  => Exec['generate /etc/postfix/virtual.db'],
  }
}
