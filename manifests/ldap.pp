# @summary Provides the Postfix LDAP support
#
# @api private
#
class postfix::ldap {
  assert_private()
  assert_type(String, $postfix::ldap_base)
  assert_type(String, $postfix::ldap_host)
  assert_type(String, $postfix::ldap_options)

  if $facts['os']['family'] == 'Debian' {
    package { 'postfix-ldap':
      before  => File["${postfix::confdir}/ldap-aliases.cf"],
    }
  }

  if ! $postfix::ldap_base {
    fail 'Missing $postfix::ldap_base !'
  }

  $ldap_host = $postfix::ldap_host ? {
    undef   => 'localhost',
    default => $postfix::ldap_host,
  }
  $ldap_base = $postfix::ldap_base
  $ldap_options = $postfix::ldap_options ? {
    undef   => '',
    default => $postfix::ldap_options,
  }

  file { "${postfix::confdir}/ldap-aliases.cf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'postfix',
    content => template('postfix/postfix-ldap-aliases.cf.erb'),
  }
}
