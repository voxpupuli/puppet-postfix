class postfix::files {
  include ::postfix::params

  $alias_maps          = $postfix::all_alias_maps
  $inet_interfaces     = $postfix::inet_interfaces
  $inet_protocols      = $postfix::inet_protocols
  $mail_user           = $postfix::mail_user
  $manage_conffiles    = $postfix::manage_conffiles
  $maincf_source       = $postfix::maincf_source
  $mastercf_source     = $postfix::mastercf_source
  $master_smtp         = $postfix::master_smtp
  $master_smtps        = $postfix::master_smtps
  $master_submission   = $postfix::master_submission
  $master_entries      = $postfix::master_entries
  $master_bounce_command = $postfix::master_bounce_command
  $master_defer_command  = $postfix::master_defer_command
  $myorigin            = $postfix::myorigin
  $manage_aliases      = $postfix::manage_aliases
  $manage_root_alias   = $postfix::manage_root_alias
  $root_mail_recipient = $postfix::root_mail_recipient
  $chroot              = $postfix::chroot
  $smtp_listen         = $postfix::_smtp_listen
  $use_amavisd         = $postfix::use_amavisd
  $use_dovecot_lda     = $postfix::use_dovecot_lda
  $use_schleuder       = $postfix::use_schleuder
  $use_sympa           = $postfix::use_sympa

  assert_type(Optional[String], $mastercf_source)
  assert_type(Optional[String], $master_smtp)
  assert_type(Optional[String], $master_smtps)

  $jail = $chroot ? {
    true    => 'y',
    default => 'n',
  }

  File {
    replace => $manage_conffiles,
  }

  file { '/etc/mailname':
    ensure  => 'file',
    content => "${::fqdn}\n",
    mode    => '0644',
    seltype => $postfix::params::seltype,
  }

  # Aliases
  if $manage_aliases {
    file { '/etc/aliases':
      ensure  => 'file',
      content => "# file managed by puppet\n",
      notify  => Exec['newaliases'],
      replace => false,
      seltype => $postfix::params::aliasesseltype,
    }
  }

  # Config files
  if $mastercf_source {
    $mastercf_content = undef
  } else {
    $mastercf_content = template(
      $postfix::params::master_os_template,
      'postfix/master.cf.common.erb'
    )
  }

  file { '/etc/postfix/master.cf':
    ensure  => 'file',
    content => $mastercf_content,
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    seltype => $postfix::params::seltype,
    source  => $mastercf_source,
  }

  # Config files
  file { '/etc/postfix/main.cf':
    ensure  => 'file',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    replace => false,
    seltype => $postfix::params::seltype,
    source  => $maincf_source,
  }

  ::postfix::config {
    'alias_maps':       value => $alias_maps;
    'inet_interfaces':  value => $inet_interfaces;
    'inet_protocols':   value => $inet_protocols;
    'myorigin':         value => $myorigin;
  }

  case $facts['os']['family'] {
    'RedHat': {
      ::postfix::config {
        'mailq_path':       value => '/usr/bin/mailq.postfix';
        'newaliases_path':  value => '/usr/bin/newaliases.postfix';
        'sendmail_path':    value => '/usr/sbin/sendmail.postfix';
      }
    }
    default: {}
  }

  if $manage_aliases and $manage_root_alias {
    postfix::mailalias {'root':
      recipient => $root_mail_recipient,
    }
  }

}
