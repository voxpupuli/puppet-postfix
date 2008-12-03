#########################################################################
#
# This class configures a minimal MTA, listening on
# $postfix_ng_smtp_listen (default to localhost) and delivering mail to
# $postfix_mydestination (default to $fqdn).
#
# A valid relay host is required ($postfix_relayhost) for outbound email.
#
# transport & virtual maps get configured and can be populated with
# postfix-ng::transport and postfix-ng::virtual
#
# Example:
#
# node "toto.example.com" {
#   $postfix_relayhost = "mail.example.com"
#   $postfix_ng_smtp_listen = "0.0.0.0"
#   $postfix_mydestination = "\$myorigin, myapp.example.com"
#
#   include postfix-ng::mta
#
#   postfix-ng::transport { "myapp.example.com":
#     ensure => present,
#     destination => "local:",
#   }
# }
#

class postfix-ng::mta {

  case $postfix_relayhost {
    "":   { fail("Required \$postfix_relayhost variable is not defined.") }
  }

  case $postfix_mydestination {
    "": { $postfix_mydestination = "\$myorigin" }
  }

  include postfix-ng

  postfix-ng::config {
    "mydestination":                        value => $postfix_mydestination;
    "mynetworks":                           value => "127.0.0.0/8";
    "relayhost":                            value => $postfix_relayhost;
    "virtual_alias_maps":                   value => "hash:/etc/postfix/virtual";
    "transport_maps":                       value => "hash:/etc/postfix/transport";
  }

  postfix-ng::hash { "/etc/postfix/virtual":
    ensure => present,
  }

  postfix-ng::hash { "/etc/postfix/transport":
    ensure => present,
  }

}
