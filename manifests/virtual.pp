# == Definition: postfix::virtual
#
# Manages content of the /etc/postfix/virtual map.
#
# === Parameters
#
# [*name*]        - name of address postfix will lookup. See virtual(8).
# [*destination*] - a list of destinations where the emails will be delivered to. See virtual(8).
# [*ensure*]      - present/absent, defaults to present.
# [*file*]        - a string defining the location of the pre-hash map.
#
# === Requires
#
# - Class["postfix"]
# - Postfix::Hash["/etc/postfix/virtual"]
# - Postfix::Config["virtual_alias_maps"]
# - augeas
#
# === Examples
#
#   node "toto.example.com" {
#
#     include postfix
# #     postfix::hash { "/etc/postfix/virtual":
#       ensure => present,
#     }
#     postfix::config { "virtual_alias_maps":
#       value => "hash:/etc/postfix/virtual"
#     }
#     postfix::virtual { "user@example.com":
#       ensure      => present,
#       destination => ['root', 'postmaster'],
#     }
#   }
#
define postfix::virtual (
  Variant[String, Array[String]] $destination,
  Stdlib::Absolutepath           $file='/etc/postfix/virtual',
  Enum['present', 'absent']      $ensure='present'
) {
  include ::postfix::augeas

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

  augeas {"Postfix virtual - ${name}":
    incl    => $file,
    lens    => 'Postfix_Virtual.lns',
    changes => $changes,
    require => Augeas::Lens['postfix_virtual'],
  }

  if defined(Package['postfix']) {
    Package['postfix'] -> Postfix::Virtual[$title]
  }

  if defined(Postfix::Hash[$file]) {
    Postfix::Virtual[$title] ~> Postfix::Hash[$file]
  }
}
