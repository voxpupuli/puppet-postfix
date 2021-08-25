# == Class: postfix::mailman
#
# Configures a basic smtp server, able to work for the mailman mailing-list
# manager.
#
# === Examples
#
# /!\ Do not include this class directly,
# use mailman => true in the postfix top class!
#
#   class { 'postfix':
#     mailman => true,
#   }
class postfix::mailman {
  include postfix

  postfix::config {
    'virtual_alias_maps':
      value => "hash:${postfix::confdir}/virtual";
    'transport_maps':
      value => "hash:${postfix::confdir}/transport";
    'mailman_destination_recipient_limit':
      value => '1';
  }

  postfix::hash { "${postfix::confdir}/virtual":
    ensure => 'present',
  }

  postfix::hash { "${postfix::confdir}/transport":
    ensure => 'present',
  }
}
