# == Definition: postfix::transport
#
# Manages content of the /etc/postfix/transport map.
#
# === Parameters
#
# [*name*]        - name of address postfix will lookup. See transport(5).
# [*destination*] - where the emails will be delivered to. See transport(5).
# [*ensure*]      - present/absent, defaults to present.
# [*nexthop*]     - A string to define where and how to deliver the mail. See transport(5).
#
# === Requires
#
# - Class["postfix"]
# - Postfix::Hash["/etc/postfix/transport"]
# - Postfix::Config["transport_maps"]
# - augeas
#
# === Examples
#
#   node 'toto.example.com' {
#
#     include postfix
#
#     postfix::hash { '/etc/postfix/transport':
#       ensure => present,
#     }
#     postfix::config { 'transport_maps':
#       value => 'hash:/etc/postfix/transport',
#     }
#     postfix::transport { 'mailman.example.com':
#       ensure      => present,
#       destination => 'mailman',
#     }
#   }
#
define postfix::transport (
  Optional[String]          $destination = undef,
  Optional[String]          $nexthop=undef,
  Stdlib::Absolutepath      $file='/etc/postfix/transport',
  Enum['present', 'absent'] $ensure='present'
) {
  include ::postfix::augeas

  case $ensure {
    'present': {
      if ($destination) {
        $change_destination = "set pattern[. = '${name}']/transport '${destination}'"
      } else {
        $change_destination = "clear pattern[. = '${name}']/transport"
      }

      if ($nexthop) {
        $change_nexthop = "set pattern[. = '${name}']/nexthop '${nexthop}'"
      } else {
        $change_nexthop = "clear pattern[. = '${name}']/nexthop"
      }

      $changes = [
        "set pattern[. = '${name}'] '${name}'",
        $change_destination,
        $change_nexthop,
      ]
    }

    'absent': {
      $changes = "rm pattern[. = '${name}']"
    }

    default: {
      fail "\$ensure must be either 'present' or 'absent', got '${ensure}'"
    }
  }

  augeas {"Postfix transport - ${name}":
    lens    => 'Postfix_Transport.lns',
    incl    => $file,
    changes => $changes,
    require => [
      Package['postfix'],
      Augeas::Lens['postfix_transport'],
      ],
    notify  => Postfix::Hash['/etc/postfix/transport'],
  }
}
