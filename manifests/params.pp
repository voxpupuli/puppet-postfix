#
# == Class: postfix::params
#
# This class provides the appropriate values for operating system specific variables.
#
# === Parameters
#
# [*mailx_package*]  - (string) Name of package that provides mailx
#
# [*restart_cmd*]    - (hash) Command to use when restarting postfix
#
# [*aliasesseltype*] - (string) Selinux type for /etc/aliases
#
# [*seltype*]        - (string) Selinux type for /etc/postfix/* config files
#
class postfix::params (
  String $mailx_package,
  String $restart_cmd,
  Optional[String] $aliasesseltype,
  Optional[String] $seltype,
) {
  case $::osfamily {
    'RedHat': {
      $master_os_template = "${module_name}/master.cf.redhat.erb"
    }

    'Debian': {
      $master_os_template = "${module_name}/master.cf.debian.erb"
    }

    'Suse': {
      if $::operatingsystemmajrelease == '11' {
        $master_os_template = "${module_name}/master.cf.${::operatingsystem}${::operatingsystemrelease}.erb"
      } else {
        $master_os_template = "${module_name}/master.cf.sles.erb"
      }
    }

    'Archlinux': {
      # I don't remember why I chose sles for arch, but it works fine
      $master_os_template = "${module_name}/master.cf.sles.erb"
    }

    default: {
      case $::operatingsystem {
        'Alpine': {
            $master_os_template = "${module_name}/master.cf.debian.erb"
        }
        default: {
          fail "Unsupported OS family '${::osfamily}' and OS '${::operatingsystem}'"
        }
      }
    }
  }
}
