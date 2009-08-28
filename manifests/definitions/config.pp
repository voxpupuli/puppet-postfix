/*
== Definition: postfix::config

Uses the "postconf" command to add/alter/remove options in postfix main
configuation file (/etc/postfix/main.cf).

Parameters:
- *name*: name of the parameter.
- *ensure*: present/absent. defaults to present.
- *value*: value of the parameter.
- *nonstandard*: inform postfix::config that this parameter is not recognized
  by the "postconf" command. defaults to false.

Requires:
- Class["postfix"]

Example usage:

  node "toto.example.com" {

    include postfix

    postfix::config {
      "smtp_use_tls"            => "yes";
      "smtp_sasl_auth_enable"   => "yes";
      "smtp_sasl_password_maps" => "hash:/etc/postfix/my_sasl_passwords";
      "relayhost"               => "[mail.example.com]:587";
    }
  }

*/
define postfix::config ($ensure = present, $value, $nonstandard = false) {
  case $ensure {
    present: {
      exec {"postconf -e ${name}='${value}'":
        unless  => $nonstandard ? {
          false => "test \"x$(postconf -h ${name})\" == 'x${value}'",
          true  => "test \"x$(egrep '^${name} ' /etc/postfix/main.cf | cut -d= -f2 | cut -d' ' -f2)\" == 'x${value}'",
        },
        notify  => Service["postfix"],
        require => File["/etc/postfix/main.cf"],
      }
    }

    absent: {
      fail "postfix::config ensure => absent: Not implemented"
    }
  }
}
