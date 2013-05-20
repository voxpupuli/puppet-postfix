class postfix::packages {
  include postfix::params

  package { 'postfix':
    ensure => installed,
  }

  package { 'mailx':
    ensure => installed,
    name   => $postfix::params::mailx_package,
  }
}
