define postfix-ng::transport ($ensure, $destination) {
  line {"${name} ${destination}":
    ensure => present,
    file   => "/etc/postfix/transport",
    line   => "${name} ${destination}",
    notify => Exec["generate /etc/postfix/transport.db"],
  }
}
