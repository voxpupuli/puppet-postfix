# == Class: postfix::mta
#
# This class configures a minimal MTA, delivering mail to
# $mydestination.
#
# Either a valid relay host or the special word 'direct' is required
# ($relayhost) for outbound email.
#
# transport & virtual maps get configured and can be populated with
# postfix::transport and postfix::virtual
#
# === Parameters
#
# [*relayhost*]     - (string) the relayhost to use or 'direct' to send mail
#                     directly without a relay.
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
  Pattern[/^\S+(?:,\s*\S+)*$/]               $mydestination = $postfix::mydestination,
  Pattern[/^(?:\S+?(?:(?:,\s)|(?:\s))?)*$/]  $mynetworks    = $postfix::mynetworks,
  Pattern[/^\S+$/]                           $relayhost     = $postfix::relayhost,
) {

  # If direct is specified then relayhost should be blank
  if ($relayhost == 'direct') {
    postfix::config { 'relayhost': ensure => 'blank' }
  }
  else {
    postfix::config { 'relayhost': value => $relayhost }
  }

  if ($mydestination == 'blank') {
    postfix::config { 'mydestination': ensure => 'blank' }
  } else {
    postfix::config { 'mydestination': value => $mydestination }
  }

  postfix::config {
    'mynetworks':          value => $mynetworks;
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
