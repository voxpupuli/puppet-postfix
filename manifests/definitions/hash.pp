define postfix-ng::hash ($ensure) {
  file {"${name}":
    ensure => $ensure,
    mode   => 600,
  }

  file {"${name}.db":
    ensure  => $ensure,
    mode    => 600,
    require => [File["${name}"], Exec["generate ${name}.db"]],
  }

  exec {"generate ${name}.db":
    command => "postmap ${name}",
    #creates => "${name}.db", # this prevents postmap from being run !
    subscribe => File["${name}"],
    refreshonly => true
  }
}
