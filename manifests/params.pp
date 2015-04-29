class postfix::params {
  case $::osfamily {
    'RedHat': {
      $seltype = $::operatingsystemmajrelease ? {
        '4'   => 'etc_t',
        /5|6|7/ => 'postfix_etc_t',
        default => undef,
      }

      $restart_cmd = $::operatingsystemmajrelease ? {
        '7'     => '/bin/systemctl restart postfix',
        default => '/etc/init.d/postfix restart',
      }

      $mailx_package = 'mailx'

      $master_os_template = "${module_name}/master.cf.redhat.erb"
    }

    'Debian': {
      $seltype = undef

      $restart_cmd = '/etc/init.d/postfix restart'

      $mailx_package = $::lsbdistcodename ? {
        /sarge|etch|lenny/ => 'mailx',
        default            => 'bsd-mailx',
      }

      $master_os_template = "${module_name}/master.cf.debian.erb"
    }

    'Suse': {
      $seltype = undef

      $restart_cmd = '/etc/init.d/postfix restart'

      $mailx_package = 'mailx'

      if $::operatingsystem != 'SLES' {
        fail "Unsupported OS '${::operatingsystem}'"
      }

      $master_os_template = "${module_name}/master.cf.${::operatingsystem}${::operatingsystemrelease}.erb"
    }

    default: {
      fail "Unsupported OS family '${::osfamily}'"
    }
  }
}
