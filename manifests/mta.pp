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
  Optional[Pattern[/^\S+(?:,\s*\S+)*$/]]                $mydestination = undef,
  Optional[Pattern[/^(?:\S+?(?:(?:,\s+)|(?:\s+))?)*$/]] $mynetworks    = undef,
  Optional[Pattern[/^\S+$/]]                            $relayhost     = undef,
  String[1]                                             $virtual_alias_maps = "hash:${postfix::confdir}/virtual",
  String[1]                                             $transport_maps     = "hash:${postfix::confdir}/transport"
) {
  include postfix

  $_mydestination = pick($mydestination, $postfix::mydestination)
  $_mynetworks = pick($mynetworks, $postfix::mynetworks)
  $_relayhost = pick($relayhost, $postfix::relayhost)

  # If direct is specified then relayhost should be blank
  if ($_relayhost == 'direct') {
    postfix::config { 'relayhost': ensure => 'blank' }
  }
  else {
    postfix::config { 'relayhost': value => $_relayhost }
  }

  if ($_mydestination == 'blank') {
    postfix::config { 'mydestination': ensure => 'blank' }
  } else {
    postfix::config { 'mydestination': value => $_mydestination }
  }

  postfix::config {
    'mynetworks':          value => $_mynetworks;
    'virtual_alias_maps':  value => $virtual_alias_maps;
    'transport_maps':      value => $transport_maps;
  }

  postfix::hash { "${postfix::confdir}/virtual":
    ensure => 'present',
  }

  postfix::hash { "${postfix::confdir}/transport":
    ensure => 'present',
  }

}
