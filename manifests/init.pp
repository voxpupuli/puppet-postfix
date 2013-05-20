#
# == Class: postfix
#
# This class provides a basic setup of postfix with local and remote
# delivery and an SMTP server listening on the loopback interface.
#
# Parameters:
# - *smtp_listen*: address on which the smtp service will listen to.
#      defaults to 127.0.0.1
# - *mail_recipient*: who will recieve root's emails. defaults to 'nobody'
#
# Example usage:
#
#     class { 'postfix': }
#
# -or-
#
#     class { 'postfix':
#       smtp_listen = '192.168.0.1',
#       inet_interfaces = 'localhost'}
class postfix (
      $smtp_listen            = '127.0.0.1',
      $root_mail_recipient    = 'root',
      $use_amavisd            = 'no',
      $use_dovecot_lda        = 'no',
      $use_schleuder          = 'no',
      $mail_user              = 'vmail',
      $myorigin               = $::fqdn,
      $inet_interfaces        = 'localhost'
    ) {

  $lsbarray = split($::operatingsystemrelease, '[.]')
  $lsbmajdistrelease = $lsbarray[0]
  # selinux labels differ from one distribution to another
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      case $lsbmajdistrelease {
        '4':     { $postfix_seltype = 'etc_t' }
        '5','6': { $postfix_seltype = 'postfix_etc_t' }
        default: { $postfix_seltype = undef }
      }
    }

    default: {
      $postfix_seltype = undef
    }
  }

  $master_os_template = $::operatingsystem ? {
    /RedHat|CentOS/          => template('postfix/master.cf.redhat.erb', 'postfix/master.cf.common.erb'),
    /Debian|Ubuntu|kFreeBSD/ => template('postfix/master.cf.debian.erb', 'postfix/master.cf.common.erb'),
  }

  package { 'postfix':
    ensure => installed,
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
    content => "${::fqdn}\n",
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

  postfix::config {
    'myorigin':         value => $myorigin;
    'alias_maps':       value => 'hash:/etc/aliases';
    'inet_interfaces':  value => $inet_interfaces;
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
