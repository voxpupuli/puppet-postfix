#
# == Class: postfix::mailman
#
# Configures a basic smtp server, able to work for the mailman mailing-list
# manager.
#
# Parameters:
# - every global variable which works for class "postfix" will work here.
#
# Example usage:
#
#   node "toto.example.com" {
#     include mailman
#     include postfix::mailman
#   }
#
class postfix::mailman {
  $postfix_smtp_listen = "0.0.0.0"
  include postfix

  postfix::config {
    "mydestination":                        value => "";
    "virtual_alias_maps":                   value => "hash:/etc/postfix/virtual";
    "transport_maps":                       value => "hash:/etc/postfix/transport";
    "mailman_destination_recipient_limit":  value => "1", nonstandard => true;
  }

  postfix::hash { "/etc/postfix/virtual":
    ensure => present,
  }

  postfix::hash { "/etc/postfix/transport":
    ensure => present,
  }

}
