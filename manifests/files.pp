class postfix::files (
  $smtp_listen,
  $root_mail_recipient,
  $use_amavisd,
  $use_dovecot_lda,
  $use_schleuder,
  $use_sympa,
  $mail_user,
  $master_smtp,
  $master_smtps,
  $master_submission,
) {
  include postfix::params

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
    'myorigin':         value => $postfix::myorigin;
    'alias_maps':       value => 'hash:/etc/aliases';
    'inet_interfaces':  value => $postfix::inet_interfaces;
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
