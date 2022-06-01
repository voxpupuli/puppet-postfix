# == Class: postfix::ldap
#
# Configures postfix for use with LDAP.
#
# === Parameters
#
# === Requires
#
# - Class["postfix"]
#
# === Examples
#
# include postfix
# include postfix::ldap
#
class postfix::ldap {
  assert_type(String, $postfix::ldap_base)
  assert_type(String, $postfix::ldap_host)
  assert_type(Optional[String], $postfix::ldap_bind_pw)
  assert_type(Optional[Variant[String,Array[String]]], $postfix::ldap_options)

  if $facts['os']['family'] in [ 'Debian', 'RedHat' ] {
    package { 'postfix-ldap':
      before  => File["${postfix::confdir}/ldap-aliases.cf"],
    }
  }

  if ! $postfix::ldap_base {
    fail 'Missing $postfix::ldap_base !'
  }

  $ldap_bind_pw = $postfix::ldap_bind_pw

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
