#== Definition: postfix::canonical
#
#Manages content of the /etc/postfix/canonical map.
#
#Parameters:
#- *name*: name of address postfix will lookup. See canonical(5).
#- *destination*: where the emails will be delivered to. See canonical(5).
#- *ensure*: present/absent, defaults to present.
#
#Requires:
#- Class["postfix"]
#- Postfix::Hash["/etc/postfix/canonical"]
#- Postfix::Config["canonical_maps"] or Postfix::Config["sender_canonical_maps"] or Postfix::Config["recipient_canonical_maps"]
#- augeas
#
#Example usage:
#
#  node "toto.example.com" {
#
#    include postfix
#
#    postfix::hash { "/etc/postfix/recipient_canonical":
#      ensure => present,
#    }
#    postfix::config { "canonical_alias_maps":
#      value => "hash:/etc/postfix/recipient_canonical"
#    }
#    postfix::canonical {
#      "user@example.com":
#        file        => "/etc/postfix/recipient_canonical",
#        ensure      => present,
#        destination => "root";
#    }
#  }
#
define postfix::canonical (
  $destination,
  $file='/etc/postfix/canonical',
  $ensure='present'
) {
  include ::postfix::augeas

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

  augeas {"Postfix canonical - ${name}":
    incl    => $file,
    lens    => 'Postfix_Canonical.lns',
    changes => $changes,
    require => [Package['postfix'], Augeas::Lens['postfix_canonical']],
    notify  => Exec["generate ${file}.db"],
  }
}
