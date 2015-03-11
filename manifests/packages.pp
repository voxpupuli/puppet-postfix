class postfix::packages {
  include ::postfix::params

  if ! defined(Package['postfix']) {
    package { 'postfix':
      ensure => installed,
    }
  }

  if ! defined(Package[$postfix::params::mailx_package]) {
    package { $postfix::params::mailx_package:
      ensure => installed,
    }
  }
}
