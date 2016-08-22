class postfix::packages {
  include ::postfix::params

  package { 'postfix':
    ensure => $postfix::postfix_ensure,
  }

  if ($postfix::manage_mailx) {
    package { 'mailx':
      ensure => $postfix::mailx_ensure,
      name   => $postfix::params::mailx_package,
    }
  }
}
