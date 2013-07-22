class postfix::ldap {

  package {'postfix-ldap': }

  if ! $::postfix::ldap_base {
    fail 'Missing $postfix_ldap_base !'
  }

  file {'/etc/postfix/ldap-aliases.cf':
    ensure  => present,
    owner   => root,
    group   => postfix,
    content => template('postfix/postfix-ldap-aliases.cf.erb'),
    require => Package['postfix-ldap'],
  }
}
