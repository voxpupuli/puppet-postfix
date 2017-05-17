#
# == Definition: postfix::config
#
# Uses Augeas to add/alter/remove options in postfix main
# configuation file (/etc/postfix/main.cf).
#
# TODO: make this a type with an Augeas and a postconf providers.
#
# === Parameters
#
# [*name*]   - name of the parameter.
# [*ensure*] - present/absent/blank. defaults to present.
# [*value*]  - value of the parameter.
#
# === Requires
#
# - Class["postfix"]
#
# === Examples
#
#   postfix::config { 'smtp_use_tls':
#     ensure => 'present',
#     value  => 'yes',
#   }
#
#   postfix::config { 'relayhost':
#     ensure => 'blank',
#   }
#
define postfix::config (
  Optional[String]                   $value  = undef,
  Enum['present', 'absent', 'blank'] $ensure = 'present',
) {

  if ($ensure == 'present') {
    assert_type(Pattern[/^.+$/], $value) |$e, $a| {
      fail '$value can not be empty if ensure = present'
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

  augeas { "manage postfix '${title}'":
    incl    => '/etc/postfix/main.cf',
    lens    => 'Postfix_Main.lns',
    changes => $changes,
    require => File['/etc/postfix/main.cf'],
  }

  Postfix::Config[$title] ~> Class['postfix::service']
}
