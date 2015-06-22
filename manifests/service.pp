class postfix::service {
  exec { 'restart postfix after packages install':
    command     => regsubst($::postfix::params::restart_cmd, 'reload', 'restart'),
    refreshonly => true,
    subscribe   => Package['postfix'],
    require     => Class['postfix::files'],
  }
  service { 'postfix':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => $::postfix::params::restart_cmd,
  }
}
