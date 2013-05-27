# == Class: postfix::mailman
#
# Configures a basic smtp server, able to work for the mailman mailing-list
# manager.
#
# Example usage:
#
#   node 'toto.example.com' {
#     class { '::postfix':
#       mailman => true,
#     }
#   }
#
# /!\ Do not include this class directly anymore,
# use mailman => true in the postfix top class!
class postfix::mailman {

  postfix::config {
    'virtual_alias_maps':
      value => 'hash:/etc/postfix/virtual';
    'transport_maps':
      value => 'hash:/etc/postfix/transport';
    'mailman_destination_recipient_limit':
      value => '1';
  }

  postfix::hash { '/etc/postfix/virtual':
    ensure => present,
  }

  postfix::hash { '/etc/postfix/transport':
    ensure => present,
  }

}
