#
#== Definition: postfix::config
#
#Uses the "postconf" command to add/alter/remove options in postfix main
#configuation file (/etc/postfix/main.cf).
#
#Parameters:
#- *name*: name of the parameter.
#- *ensure*: present/absent. defaults to present.
#- *value*: value of the parameter.
#
#Requires:
#- Class["postfix"]
#
#Example usage:
#
#  node "toto.example.com" {
#
#    include postfix
#
#    postfix::config {
#      "smtp_use_tls"            => "yes";
#      "smtp_sasl_auth_enable"   => "yes";
#      "smtp_sasl_password_maps" => "hash:/etc/postfix/my_sasl_passwords";
#      "relayhost"               => "[mail.example.com]:587";
#    }
#  }
#
#
define postfix::config ($value, $ensure = present) {

  Augeas {
    incl    => '/etc/postfix/main.cf',
    lens    => 'Postfix_Main.lns',
    notify  => Service['postfix'],
    require => File['/etc/postfix/main.cf'],
  }

  case $ensure {
    present: {
      augeas { "set postfix '${name}' to '${value}'":
        changes => "set $name '$value'",
      }
    }
    absent: {
      augeas { "rm postfix '${name}'":
        changes => "rm $name",
      }
    }
    default: {}
  }
}
