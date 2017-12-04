class postfix::service {
  exec { 'restart postfix after packages install':
    command     => regsubst($::postfix::params::restart_cmd, 'reload', 'restart'),
    refreshonly => true,
    subscribe   => Package['postfix'],
    require     => Class['postfix::files'],
  }
  service { 'postfix':
    ensure    => $::postfix::service_ensure,
    enable    => $::postfix::service_enabled,
    hasstatus => true,
    restart   => $::postfix::params::restart_cmd,
  }
  if $::osfamily == 'RedHat' {
    exec { 'alternatives --set mta /usr/sbin/sendmail.postfix':
      require => Service['postfix'],
      path    => '/bin:/sbin:/usr/bin:/usr/sbin',
      unless  => 'test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix',
    }
  }
}
