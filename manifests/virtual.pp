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
#    postfix::hash { "/etc/postfix/transport":
#      ensure => present,
#    }
#    postfix::config { "transport_maps":
#      value => "hash:/etc/postfix/transport"
#    }
#    postfix::transport { "mailman.example.com":
#      ensure      => present,
#      destination => "mailman",
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
      if ($nexthop) {
        $changes = [
          "set pattern[. = '${name}'] '${name}'",
          "set pattern[. = '${name}']/transport '${destination}'",
          # TODO: support nexthop
          "set pattern[. = '${name}']/nexthop '${nexthop}'",
        ]
      } else {
        $changes = [
          "set pattern[. = '${name}'] '${name}'",
          "set pattern[. = '${name}']/transport '${destination}'",
          # TODO: support nexthop
          "clear pattern[. = '${name}']/nexthop",
        ]
      }
    }

    'absent': {
      $changes = "rm pattern[. = '${name}']"
    }

    default: {
      fail("Wrong ensure value: ${ensure}")
    }
  }

  augeas {"Postfix virtual - ${name}":
    load_path => '/usr/share/augeas/lenses/contrib/',
    context   => "/files${file}",
    changes   => $changes,
    require   => [Package['postfix'], Augeas::Lens['postfix_transport']],
    notify    => Exec['generate /etc/postfix/virtual.db'],
  }
}
