class postfix::ldap inherits postfix {
  Postfix::Config['alias_maps'] {
    value => '"hash:/etc/aliases, ldap:/etc/postfix/ldap-aliases.cf"',
  }

  package {'postfix-ldap': }

  if ! $::postfix_ldap_base {
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
