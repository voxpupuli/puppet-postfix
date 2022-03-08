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
# [*masquerade_classes*]    - (array)
# [*masquerade_domains*]    - (array)
# [*masquerade_exceptions*] - (array)
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
  Optional[Array[String[1]]]                            $masquerade_classes  = undef,
  Optional[Array[String[1]]]                            $masquerade_domains  = undef,
  Optional[Array[String[1]]]                            $masquerade_exceptions = undef,
) {
  include postfix

  $_mydestination = pick($mydestination, $postfix::mydestination)
  $_mynetworks = pick($mynetworks, $postfix::mynetworks)
  $_relayhost = pick($relayhost, $postfix::relayhost)
  $_masquerade_classes    = pick_default($masquerade_classes, $postfix::masquerade_classes)
  $_masquerade_domains    = pick_default($masquerade_domains, $postfix::masquerade_domains)
  $_masquerade_exceptions = pick_default($masquerade_exceptions, $postfix::masquerade_exceptions)

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
    'virtual_alias_maps':  value => "hash:${postfix::confdir}/virtual";
    'transport_maps':      value => "hash:${postfix::confdir}/transport";
  }

  if ! $_masquerade_classes.empty() {
    postfix::config { 'masquerade_classes': value => join($_masquerade_classes, ' ') }
  }
  if ! $_masquerade_domains.empty() {
    postfix::config { 'masquerade_domains': value => join($_masquerade_domains, ' ') }
  }
  if ! $_masquerade_exceptions.empty() {
    postfix::config { 'masquerade_exceptions': value => join($_masquerade_exceptions, ' ') }
  }

  postfix::hash { "${postfix::confdir}/virtual":
    ensure => 'present',
  }

  postfix::hash { "${postfix::confdir}/transport":
    ensure => 'present',
  }
}
