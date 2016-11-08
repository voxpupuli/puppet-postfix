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
  if !is_string($source) and !is_array($source) { fail("value for source should be either String type or Array type got ${source}") }
  if !is_string($content) and !is_array($content) { fail("value for source should be either String type or Array type got ${content}") }
  validate_re($ensure, ['present', 'absent'],
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")

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

  Class['postfix'] -> Postfix::Hash[$title]
}
