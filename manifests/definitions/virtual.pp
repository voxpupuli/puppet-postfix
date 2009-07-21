define postfix::virtual ($ensure, $destination) {
  line {"${name} ${destination}":
    ensure => present,
    file   => "/etc/postfix/virtual",
    line   => "${name} ${destination}",
    notify => Exec["generate /etc/postfix/virtual.db"],
    require => Package["postfix"],
  }
}
