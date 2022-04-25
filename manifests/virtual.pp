# @summary Manages the contents of the virtual map.
#
# Manages content of the /etc/postfix/virtual map.
#
# @example Minimum Requirements
#   include postfix
#   postfix::hash { "/etc/postfix/virtual":
#     ensure => present,
#   }
#   postfix::config { "virtual_alias_maps":
#     value => "hash:/etc/postfix/virtual, regexp:/etc/postfix/virtual_regexp"
#   }
#
# @example Route mail to local users
#   postfix::virtual { "user@example.com":
#     ensure      => present,
#     destination => ['root', 'postmaster'],
#   }
#
# @example Regex example
#   postfix::virtual { "/.+@.+/"
#     ensure      => present,
#     file        => '/etc/postfix/virtual_regexp',
#     destination => 'root',
#   }
#
# @example Route mail bound for 'user@example.com' to root.
#   postfix::virtual {'user@example.com':
#       ensure      => present,
#       destination => 'root',
#   }
#
# @param ensure
#   A string whose valid values are present or absent.
#
# @param destination
#   A string defining where the e-mails will be delivered to, (virtual(8)).
#   Example: `root`
#
# @param file
#   A string defining the location of the virtual map, pre hash.
#   If not defined "${postfix::confdir}/virtual" will be used as path.
#   Example: `/etc/postfix/my_virtual_map`.
#
# @see https://www.postfix.org/virtual.8.html
#
define postfix::virtual (
  Variant[String, Array[String]] $destination,
  Enum['present', 'absent']      $ensure      = 'present',
  Optional[Stdlib::Absolutepath] $file        = undef
) {
  include postfix
  include postfix::augeas

  $_file = pick($file, "${postfix::confdir}/virtual")

  $dest_sets = [$destination].flatten.map |$i, $d| {
    $idx = $i+1
    "set \$entry/destination[${idx}] '${d}'"
  }

  case $ensure {
    'present': {
      $changes = [
        "defnode entry pattern[. = '${name}'] '${name}'",
        'rm $entry/destination',
        $dest_sets,
      ].flatten
    }

    'absent': {
      $changes = "rm pattern[. = '${name}']"
    }

    default: {
      fail "\$ensure must be either 'present' or 'absent', got '${ensure}'"
    }
  }

  augeas { "Postfix virtual - ${name}":
    incl    => $_file,
    lens    => 'Postfix_Virtual.lns',
    changes => $changes,
    require => Augeas::Lens['postfix_virtual'],
  }

  if defined(Package['postfix']) {
    Package['postfix'] -> Postfix::Virtual[$title]
  }

  if defined(Postfix::Hash[$_file]) {
    Postfix::Virtual[$title] ~> Postfix::Hash[$_file]
  }
}
