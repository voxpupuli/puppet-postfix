class postfix::files {
  include postfix::params

  $inet_interfaces = $postfix::inet_interfaces
  $mail_user = $postfix::mail_user
  $master_smtp = $postfix::master_smtp
  $master_smtps = $postfix::master_smtps
  $master_submission = $postfix::master_submission
  $myorigin = $postfix::myorigin
  $root_mail_recipient = $postfix::root_mail_recipient
  $smtp_listen = $postfix::smtp_listen
  $use_amavisd = $postfix::use_amavisd
  $use_dovecot_lda = $postfix::use_dovecot_lda
  $use_schleuder = $postfix::use_schleuder
  $use_sympa = $postfix::use_sympa

  file { '/etc/mailname':
    ensure  => present,
    content => "${::fqdn}\n",
    seltype => $postfix::params::seltype,
  }

  # Aliases
  file { '/etc/aliases':
    ensure  => present,
    content => "# file managed by puppet\n",
    replace => false,
    seltype => $postfix::params::seltype,
    notify  => Exec['newaliases'],
  }

  # Aliases
  exec { 'newaliases':
    command     => '/usr/bin/newaliases',
    refreshonly => true,
    subscribe   => File['/etc/aliases'],
  }

  # Config files
  file { '/etc/postfix/master.cf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template(
      $postfix::params::master_os_template,
      "${module_name}/master.cf.common.erb"
    ),
    seltype => $postfix::params::seltype,
  }

  # Config files
  file { '/etc/postfix/main.cf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/main.cf",
    replace => false,
    seltype => $postfix::params::seltype,
  }

  ::postfix::config {
    'myorigin':         value => $myorigin;
    'alias_maps':       value => 'hash:/etc/aliases';
    'inet_interfaces':  value => $inet_interfaces;
  }

  case $::osfamily {
    'RedHat': {
      ::postfix::config {
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
