# @summary Configure Postfix to work with mailman
#
# Configures a basic smtp server, able to work for the mailman mailing-list
# manager.
#
# @api private
#
class postfix::mailman {
  assert_private()

  include postfix

  postfix::config {
    'virtual_alias_maps':
      value => "${postfix::lookup_table_type}:${postfix::confdir}/virtual";
    'transport_maps':
      value => "${postfix::lookup_table_type}:${postfix::confdir}/transport";
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
