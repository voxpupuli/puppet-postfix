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
# [*ensure*] - present/absent. defaults to present.
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
define postfix::config ($value, $ensure = present) {

  validate_string($value)
  validate_string($ensure)
  validate_re($ensure, ['present', 'absent'],
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  Augeas {
    incl    => '/etc/postfix/main.cf',
    lens    => 'Postfix_Main.lns',
    require => File['/etc/postfix/main.cf'],
  }

  case $ensure {
    present: {
      augeas { "set postfix '${name}' to '${value}'":
        changes => "set ${name} '${value}'",
      }
    }
    absent: {
      augeas { "rm postfix '${name}'":
        changes => "rm ${name}",
      }
    }
    default: {}
  }
}
