# == Definition: postfix::map
#
# Creates postfix "map" files. It will create "${name}", and then build
# "${name}.db" using the "postmap" command. The map file can then be referred to
# using postfix::config.
#
# === Parameters
#
# [*name*]   - the name of the map file.
# [*ensure*] - present/absent, defaults to present.
# [*source*] - file source.
# [*type*]   - type of the postfix map (valid values are cidr, pcre, hash...)
# [*path*]   - path of the created file. By default it is placed in the
#              postfix directory
#
# === Requires
#
# - Class["postfix"]
#
# === Examples
#
#   postfix::map { '/etc/postfix/virtual':
#     ensure => present,
#   }
#   postfix::config { 'virtual_alias_maps':
#     value => 'hash:/etc/postfix/virtual',
#   }
#
define postfix::map (
  Enum['present', 'absent']             $ensure = 'present',
  Variant[Array[String], String, Undef] $source = undef,
  Variant[Array[String], String, Undef] $content = undef,
  String                                $type = 'hash',
  Stdlib::Absolutepath                  $path = "/etc/postfix/${name}",
) {
  include ::postfix::params

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  if $source and $content {
    fail 'You must provide either \'source\' or \'content\', not both'
  }

  # CIDR and PCRE maps need a postfix reload, but not a postmap
  if $type =~ /^(cidr|pcre)$/ {
    $manage_notify = Service['postfix']
  } else {
    if $ensure == 'present' {
      $manage_notify = Exec["generate ${name}.db"]
    } else {
      $manage_notify = undef
    }
  }

  file { "postfix map ${name}":
    ensure  => $ensure,
    path    => $path,
    source  => $source,
    content => $content,
    owner   => 'root',
    group   => 'postfix',
    mode    => '0644',
    require => Package['postfix'],
    notify  => $manage_notify,
  }

  if $type !~ /^(cidr|pcre)$/ {
    file {"postfix map ${name}.db":
      ensure  => $ensure,
      path    => "${path}.db",
      owner   => 'root',
      group   => 'postfix',
      mode    => '0644',
      require => [File["postfix map ${name}"], Exec["generate ${name}.db"]],
    }
  }

  exec {"generate ${name}.db":
    command     => "postmap ${path}",
    path        => $::path,
    #creates    => "${name}.db", # this prevents postmap from being run !
    refreshonly => true,
  }
}
