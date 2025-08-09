# @summary Manage content of the Postfix canonical map
#
# This type manages content of the /etc/postfix/canonical map.
#
# @example Basic usage and required setup
#   # This defined type requires the following resources:
#   # - Class["postfix"]
#   # - Postfix::Hash["/etc/postfix/canonical"]
#   # - Postfix::Config["canonical_maps"] or Postfix::Config["sender_canonical_maps"] or Postfix::Config["recipient_canonical_maps"]
#   include postfix
#   postfix::hash { '/etc/postfix/recipient_canonical':
#     ensure => present,
#   }
#   postfix::config { 'canonical_alias_maps':
#     value => 'hash:/etc/postfix/recipient_canonical',
#   }
#   postfix::canonical { 'user@example.com':
#     file        => '/etc/postfix/recipient_canonical',
#     ensure      => present,
#     destination => 'root',
#   }
#
# @param ensure
#   Intended state of the resource
#
# @param destination
#   Where the emails will be delivered to.
#
# @param file
#   Where to create the file. If not defined "${postfix::confdir}/canonical"
#   will be used as path.
#
# @param lookup_table_suffix
#   Depends on the lookup table type, which is used on the postfix::hash and postfix::config resources.
#   Default is based on the suffix type correct for `postfix::lookup_table_type` parameter.
#
# @see https://www.postfix.org/canonical.5.html
#
define postfix::canonical (
  String                   $destination,
  Enum['present','absent'] $ensure              = 'present',
  Stdlib::Absolutepath     $file                = undef,
  Optional[String[1]]      $lookup_table_suffix = undef,
) {
  include postfix

  $_lookup_table_suffix = $lookup_table_suffix ? {
    Undef   => postfix::table_type_extension($postfix::lookup_table_type),
    default => $lookup_table_suffix,
  }

  $_file = pick($file, "${postfix::confdir}/canonical")

  case $ensure {
    'present': {
      $changes = [
        "set pattern[. = '${name}'] '${name}'",
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

  augeas { "Postfix canonical - ${name}":
    incl    => $_file,
    lens    => 'postfix_canonical.lns',
    changes => $changes,
    require => Package['postfix'],
    notify  => Exec["generate ${_file}.${_lookup_table_suffix}"],
  }
}
