#
# == Class: postfix
#
# This class provides a basic setup of postfix with local and remote
# delivery and an SMTP server listening on the loopback interface.
#
# Parameters:
# - *$postfix_smtp_listen*: address on which the smtp service will listen to.
#      defaults to 127.0.0.1
# - *$root_mail_recipient*: who will recieve root's emails. defaults to 'nobody'
#
# Example usage:
#
#   node 'toto.example.com' {
#     $postfix_smtp_listen = '192.168.1.10'
#     include postfix
#   }
#
class postfix {

  # selinux labels differ from one distribution to another
  case $::operatingsystem {

    RedHat, CentOS: {
      case $::lsbmajdistrelease {
        '4':     { $postfix_seltype = 'etc_t' }
        '5','6': { $postfix_seltype = 'postfix_etc_t' }
        default: { $postfix_seltype = undef }
      }
    }

    default: {
      $postfix_seltype = undef
    }
  }

  # Default value for various options
  if $postfix_smtp_listen == '' {
    $postfix_smtp_listen = '127.0.0.1'
  }
  if $root_mail_recipient == '' {
    $root_mail_recipient = 'nobody'
  }
  if $postfix_use_amavisd == '' {
    $postfix_use_amavisd = 'no'
  }
  if $postfix_use_dovecot_lda == '' {
    $postfix_use_dovecot_lda = 'no'
  }
  if $postfix_use_schleuder == '' {
    $postfix_use_schleuder = 'no'
  }
  if $postfix_use_sympa == '' {
    $postfix_use_sympa = 'no'
  }
  if $postfix_mail_user == '' {
    $postfix_mail_user = 'vmail'
  }

  case $::operatingsystem {
    /RedHat|CentOS|Fedora/: {
      $mailx_package = 'mailx'
    }

    /Debian|kFreeBSD/: {
      $mailx_package = $::lsbdistcodename ? {
        /lenny|etch|sarge/ => 'mailx',
        default            => 'bsd-mailx',
      }
    }

    'Ubuntu': {
      if (versioncmp('10', $::lsbmajdistrelease) > 0) {
        $mailx_package = 'mailx'
      } else {
        $mailx_package = 'bsd-mailx'
      }
    }
  }

  $master_os_template = $::operatingsystem ? {
    /RedHat|CentOS/          => template('postfix/master.cf.redhat.erb', 'postfix/master.cf.common.erb'),
    /Debian|Ubuntu|kFreeBSD/ => template('postfix/master.cf.debian.erb', 'postfix/master.cf.common.erb'),
  }

  package { 'postfix':
    ensure => installed,
  }

  package { 'mailx':
    ensure => installed,
    name   => $mailx_package,
  }

  service { 'postfix':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => '/etc/init.d/postfix reload',
    require   => Package['postfix'],
  }

  file { '/etc/mailname':
    ensure  => present,
    content => "$::fqdn\n",
    seltype => $postfix_seltype,
  }

  # Aliases
  file { '/etc/aliases':
    ensure  => present,
    content => '# file managed by puppet\n',
    replace => false,
    seltype => $postfix_seltype,
    notify  => Exec['newaliases'],
  }

  # Aliases
  exec { 'newaliases':
    command     => '/usr/bin/newaliases',
    refreshonly => true,
    require     => Package['postfix'],
    subscribe   => File['/etc/aliases'],
  }

  # Config files
  file { '/etc/postfix/master.cf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $master_os_template,
    seltype => $postfix_seltype,
    notify  => Service['postfix'],
    require => Package['postfix'],
  }

  # Config files
  file { '/etc/postfix/main.cf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/postfix/main.cf',
    replace => false,
    seltype => $postfix_seltype,
    notify  => Service['postfix'],
    require => Package['postfix'],
  }

  # Default configuration parameters
  $myorigin = $valid_fqdn ? {
    ''      => $::fqdn,
    default => $valid_fqdn,
  }
  postfix::config {
    'myorigin':         value => $myorigin;
    'alias_maps':       value => 'hash:/etc/aliases';
    'inet_interfaces':  value => 'all';
  }

  case $::operatingsystem {
    RedHat, CentOS: {
      postfix::config {
        'sendmail_path':    value => '/usr/sbin/sendmail.postfix';
        'newaliases_path':  value => '/usr/bin/newaliases.postfix';
        'mailq_path':       value => '/usr/bin/mailq.postfix';
      }
    }
    default: {}
  }

  mailalias {'root':
    recipient => $root_mail_recipient,
    notify    => Exec['newaliases'],
  }
}
