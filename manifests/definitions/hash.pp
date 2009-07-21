define postfix::hash ($ensure) {
  file {"${name}":
    ensure => $ensure,
    mode   => 600,
    seltype => "postfix_etc_t",
    require => Package["postfix"],
  }

  file {"${name}.db":
    ensure  => $ensure,
    mode    => 600,
    require => [File["${name}"], Exec["generate ${name}.db"]],
    seltype => "postfix_etc_t",
  }

  exec {"generate ${name}.db":
    command => "postmap ${name}",
    #creates => "${name}.db", # this prevents postmap from being run !
    subscribe => File["${name}"],
    refreshonly => true,
    require => Package["postfix"],
  }
}
