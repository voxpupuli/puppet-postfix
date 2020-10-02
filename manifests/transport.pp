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
#       value => 'hash:/etc/postfix/transport, regexp:/etc/postfix/transport_regexp',
#     }
#     postfix::transport {
#       'mailman.example.com':
#          ensure      => present,
#          destination => 'mailman';
#       'slow_transport':
#          ensure      => present,
#          nexthop     => '/^user-.*@mydomain\.com/'
#          file        => '/etc/postfix/transport_regexp',
#          destination => 'slow'
#     }
#     
#   }
#
define postfix::transport (
  Optional[String]          $destination = undef,
  Optional[String]          $nexthop=undef,
  Stdlib::Absolutepath      $file='/etc/postfix/transport',
  Enum['present', 'absent'] $ensure='present'
) {
  include ::postfix::augeas

  $smtp_nexthop = ("${nexthop}" =~ /\[.*\]/)

  case $ensure {
    'present': {
      if ($smtp_nexthop) {
        $change_destination = "rm pattern[. = '${name}']/transport"
      } else  {
        if ($destination) {
          $change_destination = "set pattern[. = '${name}']/transport '${destination}'"
        } else {
          $change_destination = "clear pattern[. = '${name}']/transport"
        }
      }

      if ($nexthop) {
        if ($smtp_nexthop) {
          $nexthop_split = split($nexthop, ':')
          $change_nexthop = [
            "rm pattern[. = '${name}']/nexthop",
            "set pattern[. = '${name}']/host '${nexthop_split[0]}'",
            "set pattern[. = '${name}']/port '${nexthop_split[1]}'",
          ]
        } else {
          $change_nexthop = [
            "rm pattern[. = '${name}']/host",
            "rm pattern[. = '${name}']/port",
            "set pattern[. = '${name}']/nexthop '${nexthop}'",
          ]
        }
      } else {
        $change_nexthop = [
          "clear pattern[. = '${name}']/nexthop",
          "rm pattern[. = '${name}']/host",
          "rm pattern[. = '${name}']/port",
        ]
      }

      $changes = flatten([
        "set pattern[. = '${name}'] '${name}'",
        $change_destination,
        $change_nexthop,
      ])
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
    require => Augeas::Lens['postfix_transport'],
  }

  if defined(Package['postfix']) {
    Package['postfix'] -> Postfix::Transport[$title]
  }

  if defined(Postfix::Hash['/etc/postfix/transport']) {
    Postfix::Transport[$title] ~> Postfix::Hash['/etc/postfix/transport']
  }
}
