class postfix-ng::mailman {
  $postfix_ng_smtp_listen = "0.0.0.0"
  include postfix-ng

  postfix-ng::config {
    "mydestination":                        value => "";
    "virtual_alias_maps":                   value => "hash:/etc/postfix/virtual";
    "transport_maps":                       value => "hash:/etc/postfix/transport";
    "mailman_destination_recipient_limit":  value => "1", nonstandard => true;
  }

  postfix-ng::hash { "/etc/postfix/virtual":
    ensure => present,
  }

  postfix-ng::hash { "/etc/postfix/transport":
    ensure => present,
  }

}
