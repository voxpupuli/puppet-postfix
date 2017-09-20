# == Definition: postfix::hash
#
# Creates postfix hashed "map" files. It will create "${name}", and then build
# "${name}.db" using the "postmap" command. The map file can then be referred to
# using postfix::config.
#
# === Parameters
#
# [*name*]    - the name of the map file.
# [*ensure*]  - present/absent, defaults to present.
# [*source*]  - file source. Mutially exclusive with "content".
# [*content*] - content of the file. Mutially exclusive with "source".
#
# === Requires
#
# - Class["postfix"]
#
# === Examples
#
#   postfix::hash { 'virtual':
#     ensure => present,
#   }
#   postfix::config { 'virtual_alias_maps':
#     value => 'hash:/etc/postfix/virtual',
#   }
#
define postfix::hash (
  Enum['present', 'absent']             $ensure='present',
  Variant[Array[String], String, Undef] $source=undef,
  Variant[Array[String], String, Undef] $content=undef,
) {
  include ::postfix::params

  assert_type(Stdlib::Absolutepath, $name)

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  if $source and $content {
    fail 'You must provide either \'source\' or \'content\', not both'
  }

  postfix::map {$name:
    ensure  => $ensure,
    source  => $source,
    content => $content,
    type    => 'hash',
    path    => $name,
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
