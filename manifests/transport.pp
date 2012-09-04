#== Definition: postfix::transport
#
#Manages content of the /etc/postfix/transport map.
#
#Parameters:
#- *name*: name of address postfix will lookup. See transport(5).
#- *destination*: where the emails will be delivered to. See transport(5).
#- *ensure*: present/absent, defaults to present.
#
#Requires:
#- Class["postfix"]
#- Postfix::Hash["/etc/postfix/transport"]
#- Postfix::Config["transport_maps"]
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
define postfix::transport (
  $destination,
  $nexthop='',
  $file='/etc/postfix/transport',
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

  augeas {"Postfix transport - ${name}":
    load_path => '/usr/share/augeas/lenses/contrib/',
    context   => "/files${file}",
    changes   => $changes,
    require   => [Package['postfix'], Augeas::Lens['postfix_transport']],
    notify    => Exec['generate /etc/postfix/transport.db'],
  }
}
