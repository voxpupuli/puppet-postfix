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
#              postfix directory.
# [*mode*]   - mode of the created file. By default it is '0640'.
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
  Enum['present', 'absent'] $ensure = 'present',
  Optional[Variant[Array[String], String]] $source = undef,
  Optional[Variant[Sensitive[String], String]] $content = undef,
  String[1] $type = 'hash',
  Optional[Stdlib::Absolutepath] $path = undef,
  String[4,4] $mode = '0640',
) {
  include postfix
  include postfix::params

  $_path = pick($path, "${postfix::confdir}/${name}")

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  if $source and $content {
    fail 'You must provide either \'source\' or \'content\', not both'
  }

  # CIDR and PCRE maps need a postfix reload, but not a postmap
  if $type =~ /^(cidr|pcre|regexp)$/ {
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
    path    => $_path,
    source  => $source,
    content => $content,
    owner   => 'root',
    group   => 'postfix',
    mode    => $mode,
    require => Package['postfix'],
    notify  => $manage_notify,
  }

  if $type !~ /^(cidr|pcre|regexp)$/ {
    file { "postfix map ${name}.db":
      ensure  => $ensure,
      path    => "${_path}.db",
      owner   => 'root',
      group   => 'postfix',
      mode    => $mode,
      require => File["postfix map ${name}"],
      notify  => $manage_notify,
    }
  }

  $generate_cmd = $ensure ? {
    'absent'  => "rm ${_path}.db",
    'present' => "postmap ${_path}",
  }

  exec { "generate ${name}.db":
    command     => $generate_cmd,
    path        => $facts['path'],
    #creates    => "${name}.db", # this prevents postmap from being run !
    refreshonly => true,
  }
}
