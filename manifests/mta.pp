# == Class: postfix::mta
#
# This class configures a minimal MTA, delivering mail to
# $mydestination.
#
# A valid relay host is required ($relayhost) for outbound email.
#
# transport & virtual maps get configured and can be populated with
# postfix::transport and postfix::virtual
#
# === Parameters
#
# [*relayhost*]     - (string) the relayhost to use
# [*mydestination*] - (string)
# [*mynetworks*]    - (string)
#
# === Examples
#
#   class { 'postfix':
#     relayhost     => 'mail.example.com',
#     smtp_listen   => '0.0.0.0',
#     mydestination => '$myorigin, myapp.example.com',
#     mta           => true,
#   }
#
class postfix::mta (
  $mydestination = $postfix::mydestination,
  $mynetworks    = $postfix::mynetworks,
  $relayhost     = $postfix::relayhost,
) {

  validate_re($relayhost, '^\S+$',
              'Wrong value for $relayhost')
  validate_re($mydestination, '^\S+(?:,\s*\S+)*$',
              'Wrong value for $mydestination')
  validate_re($mynetworks, '^\S+$',
              'Wrong value for $mynetworks')

  postfix::config {
    'mydestination':       value => $mydestination;
    'mynetworks':          value => $mynetworks;
    'relayhost':           value => $relayhost;
    'virtual_alias_maps':  value => 'hash:/etc/postfix/virtual';
    'transport_maps':      value => 'hash:/etc/postfix/transport';
  }

  postfix::hash { '/etc/postfix/virtual':
    ensure => 'present',
  }

  postfix::hash { '/etc/postfix/transport':
    ensure => 'present',
  }

}
