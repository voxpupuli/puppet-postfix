# == Definition: postfix::hash
#
# Creates postfix hashed "map" files. It will create "${name}", and then build
# "${name}.db" using the "postmap" command. The map file can then be referred to
# using postfix::config.
#
# === Parameters
#
# [*name*]   - the name of the map file.
# [*ensure*] - present/absent, defaults to present.
# [*source*] - file source.
#
# === Requires
#
# - Class["postfix"]
#
# === Examples
#
#   postfix::hash { '/etc/postfix/virtual':
#     ensure => present,
#   }
#   postfix::config { 'virtual_alias_maps':
#     value => 'hash:/etc/postfix/virtual',
#   }
#
define postfix::hash (
  $ensure='present',
  $source=undef,
  $content=undef,
) {
  include ::postfix::params

  validate_absolute_path($name)
#  validate_string($source)
#  validate_string($content)
  if !is_string($source) and !is_array($source) { fail("value for source should be either String type or Array type got ${source}") }
  if !is_string($content) and !is_array($content) { fail("value for source should be either String type or Array type got ${content}") }
  validate_string($ensure)
  validate_re($ensure, ['present', 'absent'],
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  if $source and $content {
    fail 'You must provide either \'source\' or \'content\', not both'
  }

  File {
    mode    => '0600',
    owner   => root,
    group   => root,
    seltype => $postfix::params::seltype,
  }

  file { $name:
    ensure  => $ensure,
    source  => $source,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['postfix'],
  }

  file {"${name}.db":
    ensure  => $ensure,
    require => [File[$name], Exec["generate ${name}.db"]],
  }

  exec {"generate ${name}.db":
    command     => "postmap ${name}",
    path        => $::path,
    #creates    => "${name}.db", # this prevents postmap from being run !
    subscribe   => File[$name],
    refreshonly => true,
  }

  # If ${name} hasn't been modified, then the above exec might *never* be run.
  # In this situation, we could end up with an empty (invalid) .db file when
  # the 'file {"${name}.db":}' resource touches us an empty file...
  # To fix this, we can use another postmap exec that only runs if we have a 0 byte .db file
  # that needs fixing.
  exec {"Force generate ${name}.db as current ${name}.db is 0 bytes":
    command => "postmap ${name}",
    path    => $::path,
    # run this command unless .db file doesn't exist OR .db file exists but isn't empty
    unless  => "test ! -f ${name}.db || test -s ${name}.db",
    require => File["${name}.db"],
  }

  Class['postfix'] -> Postfix::Hash[$title]
}
