# @summary Install the required packages for postfix
#
# @api private
#
class postfix::packages {
  assert_private()

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
