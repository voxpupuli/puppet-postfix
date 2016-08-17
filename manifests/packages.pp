class postfix::packages {
  include ::postfix::params

  package { 'postfix':
    ensure => $postfix::postfix_ensure,
  }

  if ! defined(Package['mailx']) {
    package { 'mailx':
      ensure => $postfix::mailx_ensure,
      name   => $postfix::params::mailx_package,
    }
  }

}
