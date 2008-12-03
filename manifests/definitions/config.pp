define postfix-ng::config ($ensure = present, $value, $nonstandard = false) {
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
      fail "postfix-ng::config ensure => absent: Not implemented"
    }
  }
}
