class postfix::ldap {

  package {'postfix-ldap': }

  if ! $::postfix::ldap_base {
    fail 'Missing $postfix_ldap_base !'
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

  file {'/etc/postfix/ldap-aliases.cf':
    ensure  => present,
    owner   => root,
    group   => postfix,
    content => template('postfix/postfix-ldap-aliases.cf.erb'),
    require => Package['postfix-ldap'],
  }
}
