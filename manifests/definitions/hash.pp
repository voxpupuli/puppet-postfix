define postfix::hash ($ensure) {

  case $operatingsystem {

    RedHat: {
      case $lsbmajdistrelease {
        "4":     { $postfix_seltype = "etc_t" }
        "5":     { $postfix_seltype = "postfix_etc_t" }
        default: { $postfix_seltype = undef }
      }
    }

    default: {
      $postfix_seltype = undef
    }
  }

  file {"${name}":
    ensure => $ensure,
    mode   => 600,
    seltype => $postfix_seltype,
    require => Package["postfix"],
  }

  file {"${name}.db":
    ensure  => $ensure,
    mode    => 600,
    require => [File["${name}"], Exec["generate ${name}.db"]],
    seltype => $postfix_seltype,
  }

  exec {"generate ${name}.db":
    command => "postmap ${name}",
    #creates => "${name}.db", # this prevents postmap from being run !
    subscribe => File["${name}"],
    refreshonly => true,
    require => Package["postfix"],
  }
}
