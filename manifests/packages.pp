class postfix::packages {
  include ::postfix::params

  if $::osfamily == 'RedHat' and versioncmp($::operatingsystemmajrelease, '6') <= 0 {
    package { 'sendmail':
      ensure  => absent,
      require => Package['postfix'],
    }
  }

  package { 'postfix':
    ensure => $postfix::postfix_ensure,
  }

  package { 'mailx':
    ensure => $postfix::mailx_ensure,
    name   => $postfix::params::mailx_package,
  }
}
