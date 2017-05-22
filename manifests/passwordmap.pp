# == Definition: postfix::passwordmap
#
# Manages content of the /etc/postfix/*passwd password maps.
#
# === Parameters
#
# [*ensure*]      - present/absent, defaults to present.
# [*name*]        - domain, hostname or adress postfix will lookup. 
# [*username*]    - username for authentication.
# [*password*]    - password for authentication.
#
# === Requires
#
# - Class["postfix"]
# - Postfix::Hash["/etc/postfix/passwd"]
# - Postfix::Config["smtp_sasl_password_maps"]  or
#   Postfix::Config["lmtp_sasl_password_maps"]
# - augeas
#
# === Examples
#
#   node 'toto.example.com' {
#
#     include postfix
#
#     postfix::hash { '/etc/postfix/passwd':
#       ensure => present,
#     }
#     postfix::config { 'smtp_sasl_password_maps':
#       value => 'hash:/etc/postfix/passwd',
#     }
#     postfix::passwordmap { 'isp.example.com':
#       file     => /etc/postfix/passwd
#       ensure   => present,
#       username => 'username',
#       password => 'p@ssw0rd',
#     }
#   }
#
define postfix::passwordmap (
  $file     = undef,
  $username = undef,
  $password = undef,
  $ensure   = 'present',
) {

  # Validation
  validate_absolute_path($file)
  validate_string($ensure)

  # Username must be always set
  if !is_string($username) {
    fail('Username must be a none empty string')
  }

  # Optional password should be a string
  validate_string($password)

  include ::postfix::augeas

  case $ensure {
    'present': {
      if ($password) {
        $change_password = "set pattern[. = '${name}']/password '${password}'"
      } else {
        $change_password = "clear pattern[. = '${name}']/password"
      }

      $changes = [
        "set pattern[. = '${name}'] '${name}'",
        "set pattern[. = '${name}']/username '${username}'",
        $change_password
      ]

    }

    'absent': {
      $changes = "rm pattern[. = '${name}']"
    }

    default: {
      fail "\$ensure must be either 'present' or 'absent', got '${ensure}'"
    }
  }

  augeas {"Postfix passwordmap - ${name}":
    incl      => $file,
    lens      => 'Postfix_Passwordmap.lns',
    load_path => $::augeas::lens_dir,
    changes   => $changes,
    show_diff => false,
    require   => [
      Package['postfix'],
      Augeas::Lens['postfix_passwordmap']
      ],
    notify    => Postfix::Hash[$file],
  }

}
