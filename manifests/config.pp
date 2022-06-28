# @summary Set values in Postfix config file
#
# Add/alter/remove options in Postfix main configuration file (main.cf).
# This uses Augeas to do the editing of the configuration file, as such any
# configuration value can be used.
#
# @example Set value for smtp_use_tls
#   postfix::config { 'smtp_use_tls':
#     ensure => 'present',
#     value  => 'yes',
#   }
#
# @example Set a config parameter with empty value
#   postfix::config { 'relayhost':
#     ensure => 'blank',
#   }
#
# @example Configure Postfix to use TLS as a client
#   postfix::config {
#     'smtp_tls_mandatory_ciphers':       value   => 'high';
#     'smtp_tls_security_level':          value   => 'secure';
#     'smtp_tls_CAfile':                  value   => '/etc/pki/tls/certs/ca-bundle.crt';
#     'smtp_tls_session_cache_database':  value   => 'btree:${data_directory}/smtp_tls_session_cache';
#   }
#
# @example Configure Postfix to disable the vrfy command
#   postfix::config { 'disable_vrfy_command':
#     ensure  => present,
#     value   => 'yes',
#   }
#
# @param ensure
#   Defines if the config parameter is present, absent or blank.
#   The special value 'blank', will clear the value for the parameter,
#   but will not remove it from the config file.
#   Example: `blank`
#
# @param value
#   A string that can contain any text to be used as the configuration value.
#   Example: `btree:${data_directory}/smtp_tls_session_cache`.
#
define postfix::config (
  Optional[String]                   $value  = undef,
  Enum['present', 'absent', 'blank'] $ensure = 'present',
) {
  include postfix

  if ($ensure == 'present') {
    assert_type(Pattern[/^.+$/], $value) |$e, $a| {
      fail "value for parameter: ${title} can not be empty if ensure = present"
    }
  }

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  case $ensure {
    'present': {
      $changes = "set ${name} '${value}'"
    }
    'absent': {
      $changes = "rm ${name}"
    }
    'blank': {
      $changes = "clear ${name}"
    }
    default: {
      fail "Unknown value for ensure '${ensure}'"
    }
  }

  # TODO: make this a type with an Augeas and a postconf providers.
  augeas { "manage postfix '${title}'":
    incl    => "${postfix::confdir}/main.cf",
    lens    => 'Postfix_Main.lns',
    changes => $changes,
    require => File["${postfix::confdir}/main.cf"],
  }

  Postfix::Config[$title] ~> Class['postfix::service']
}
