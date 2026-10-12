# @summary Manage service resources for postfix
#
# @api private
#
class postfix::service {
  assert_private()

  $manage_aliases = $postfix::manage_aliases

  service { 'postfix':
    ensure    => $postfix::service_ensure,
    enable    => $postfix::service_enabled,
    hasstatus => true,
    restart   => $postfix::params::restart_cmd,
    subscribe => Package['postfix'],
    require   => Class['postfix::files'],
  }
  # Aliases
  if $manage_aliases {
    exec { 'newaliases':
      command     => 'newaliases',
      path        => $facts['path'],
      refreshonly => true,
      subscribe   => File[regsubst($postfix::alias_maps, '^.*:', '')],
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
