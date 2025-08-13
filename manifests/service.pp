# @summary Manage service resources for postfix
#
# @api private
#
class postfix::service {
  assert_private()

  $manage_aliases = $postfix::manage_aliases

  exec { 'restart postfix after packages install':
    command     => regsubst($postfix::restart_cmd, 'reload', 'restart'),
    refreshonly => true,
    subscribe   => Package['postfix'],
    require     => Class['postfix::files'],
  }
  service { 'postfix':
    ensure    => $postfix::service_ensure,
    enable    => $postfix::service_enabled,
    hasstatus => true,
    restart   => $postfix::restart_cmd,
  }
  # Aliases
  if $manage_aliases {
    exec { 'newaliases':
      command     => 'newaliases',
      path        => $facts['path'],
      refreshonly => true,
      subscribe   => File['/etc/aliases'],
      require     => Service['postfix'],
    }
  }
  if $postfix::mta_bin_path {
    alternatives { 'mta':
      path    => $postfix::mta_bin_path,
      require => Service['postfix'],
    }
  }
}
