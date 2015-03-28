class postfix::service {
  service { 'postfix':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => $::postfix::params::restart_cmd,
  }
}
