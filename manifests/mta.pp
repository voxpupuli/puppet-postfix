#
# == Class: postfix::mta
#
# This class configures a minimal MTA, listening on
# $postfix_smtp_listen (default to localhost) and delivering mail to
# $postfix_mydestination (default to $fqdn).
#
# A valid relay host is required ($postfix_relayhost) for outbound email.
#
# transport & virtual maps get configured and can be populated with
# postfix::transport and postfix::virtual
#
# Parameters:
# - *$postfix_relayhost*
# - *$postfix_mydestination*
# - every global variable which works for class 'postfix' will work here.
#
# Example usage:
#
#   node 'toto.example.com' {
#     $postfix_relayhost = 'mail.example.com'
#     $postfix_smtp_listen = '0.0.0.0'
#     $postfix_mydestination = '$myorigin, myapp.example.com'
#
#     include postfix::mta
#
#     postfix::transport { 'myapp.example.com':
#       ensure => present,
#       destination => 'local:',
#     }
#   }
#
class postfix::mta {

  $mydestination = $postfix::mydestination ? {
    undef   => '$myorigin',
    default => $postfix::mydestination,
  }

  $mynetworks = $postfix::mynetworks ? {
    undef   => '127.0.0.1/8',
    default => $postfix::mynetworks,
  }

  validate_re($postfix::relayhost, '^\S+$',
              'You must pass $relayhost to the postfix class')
  validate_re($mydestination, '^\S+$',
              'Wrong value for $mydestination')
  validate_re($mynetworks, '^\S+$',
              'Wrong value for $mynetworks')

  postfix::config {
    'mydestination':       value => $mydestination;
    'mynetworks':          value => $mynetworks;
    'relayhost':           value => $postfix::relayhost;
    'virtual_alias_maps':  value => 'hash:/etc/postfix/virtual';
    'transport_maps':      value => 'hash:/etc/postfix/transport';
  }

  postfix::hash { '/etc/postfix/virtual':
    ensure => present,
  }

  postfix::hash { '/etc/postfix/transport':
    ensure => present,
  }

}
