# @summary Manage the transport map of postfix
#
# Manages content of the /etc/postfix/transport map.
#
# @example Simple transport map config
#   include postfix
#   postfix::hash { '/etc/postfix/transport':
#     ensure => present,
#   }
#   postfix::config { 'transport_maps':
#     value => 'hash:/etc/postfix/transport, regexp:/etc/postfix/transport_regexp',
#   }
#   postfix::transport {
#     'mailman.example.com':
#        ensure      => present,
#        destination => 'mailman';
#     'slow_transport':
#        ensure      => present,
#        nexthop     => '/^user-.*@mydomain\.com/'
#        file        => '/etc/postfix/transport_regexp',
#        destination => 'slow'
#   }
#
# @param ensure
#   Defines whether the transport entry is present or not. Value can either be present or absent.
#
# @param destination
#   The destination to be delivered to (transport(5)).
#   Example: `mailman`.
#
# @param nexthop
#   A string to define where and how to deliver the mail (transport(5)).
#   Example: `[smtp.google.com]:25`.
#
# @param file
#   Where to create the file. If not defined "${postfix::confdir}/transport"
#   will be used as path.
#
# @see https://www.postfix.org/transport.5.html
#
define postfix::transport (
  Enum['present', 'absent']      $ensure      = 'present',
  Optional[String]               $destination = undef,
  Optional[String]               $nexthop     = undef,
  Optional[Stdlib::Absolutepath] $file        = undef,
) {
  include postfix
  include postfix::augeas

  $_file = pick($file, "${postfix::confdir}/transport")

  $smtp_nexthop = (String($nexthop) =~ /\[.*\]/)

  case $ensure {
    'present': {
      if ($smtp_nexthop) {
        $change_destination = "rm pattern[. = '${name}']/transport"
      } else {
        if ($destination) {
          $change_destination = "set pattern[. = '${name}']/transport '${destination}'"
        } else {
          $change_destination = "clear pattern[. = '${name}']/transport"
        }
      }

      if ($nexthop) {
        # This is some paranoia over splitting.  We can't do a simple split here, as there
        # could be ipv6 addrs in a nexthop's host.  So we're definitely into neeeding a regexp.
        # The regexp needs to be 'the same base' as used in smtp_nexthop above, while also
        # capturing the port.
        # From https://github.com/voxpupuli/puppet-postfix/issues/241, this exists
        # to handle [host]:port nexthop.  Other cases are handled by simply passing nexthop
        # straight through.
        $nexthop_match = $nexthop.match(/(:?\[.*\]):(\d+)/)
        # If this matched, we'll have a length of 3: [whole string, host, port].
        if ($nexthop_match =~ Array and $nexthop_match.length == 3) {
          $change_nexthop = [
            "rm pattern[. = '${name}']/nexthop",
            "set pattern[. = '${name}']/host '${nexthop_match[1]}'",
            "set pattern[. = '${name}']/port '${nexthop_match[2]}'",
          ]
        } else {
          # If it didn't match, we just report the nexthop unmodified; remove any breakout of
          # host/port that may have existed.
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

  augeas { "Postfix transport - ${name}":
    lens    => 'Postfix_Transport.lns',
    incl    => $_file,
    changes => $changes,
    require => Augeas::Lens['postfix_transport'],
  }

  if defined(Package['postfix']) {
    Package['postfix'] -> Postfix::Transport[$title]
  }

  if defined(Postfix::Hash[$_file]) {
    Postfix::Transport[$title] ~> Postfix::Hash[$_file]
  }
}
