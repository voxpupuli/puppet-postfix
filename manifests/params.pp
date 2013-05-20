class postfix::params {
  case $::osfamily {
    'RedHat': {
      $seltype = $::lsbmajdistrelease ? {
        '4'   => 'etc_t',
        /5|6/ => 'postfix_etc_t',
        default => undef,
      }

      $mailx_package = 'mailx'

      $master_os_template = "${module_name}/master.cf.redhat.erb"
    }

    'Debian': {
      $seltype = undef

      $mailx_package = $::lsbdistcodename ? {
        /sarge|etch|lenny|lucid/ => 'mailx',
        default                  => 'bsd-mailx',
      }

      $master_os_template = "${module_name}/master.cf.debian.erb"
    }

    default: {
      fail "Unsupported OS family '${::osfamily}'"
    }
  }
}
