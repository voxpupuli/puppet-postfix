# @summary Create a Postfix map file
#
# Creates Postfix "map" files. It will create "${name}", and then build
# "${name}.db" using the "postmap" command. The map file can then be referred to
# using postfix::config.
#
# @example Postfix map file and use in config
#   postfix::map { '/etc/postfix/virtual':
#     ensure => present,
#   }
#   postfix::config { 'virtual_alias_maps':
#     value => 'hash:/etc/postfix/virtual',
#   }
#
# @param ensure
#   Intended state of the resource
#
# @param source
#   Sets the value of the source parameter for the file. Can't be used
#   together with parameter content.
#
# @param content
#   The content of the file. Can't be used together with param source.
#
# @param type
#   Type of the Postfix map (valid values are cidr, pcre, hash...)
#
# @param path
#   Where to create the file. If not defined "${postfix::confdir}/${name}"
#   will be used as path.
#
# @param mode
#   File mode of the created file.
#
# @see http://www.postfix.org/postmap.1.html
#
define postfix::map (
  Enum['present', 'absent']                    $ensure  = 'present',
  Optional[Variant[Array[String], String]]     $source  = undef,
  Optional[Variant[Sensitive[String], String]] $content = undef,
  String[1]                                    $type    = 'hash',
  Optional[Stdlib::Absolutepath]               $path    = undef,
  String[4,4]                                  $mode    = '0640',
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

  $_generated_suffix = $type ? {
    'cdb'   => 'cdb',
    'dbm'   => 'dir',
    'lmdb'  => 'lmdb',
    'sdbm'  => 'dir',
    default => 'db',
  }

  # CIDR and PCRE maps need a postfix reload, but not a postmap
  if $type =~ /^(cidr|pcre|regexp)$/ {
    $manage_notify = Service['postfix']
  } else {
    if $ensure == 'present' {
      $manage_notify = Exec["generate ${name}.${_generated_suffix}"]
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
    file { "postfix map ${name}.${_generated_suffix}":
      ensure  => $ensure,
      path    => "${_path}.${_generated_suffix}",
      owner   => 'root',
      group   => 'postfix',
      mode    => $mode,
      require => File["postfix map ${name}"],
      notify  => $manage_notify,
    }
  }

  $generate_cmd = $ensure ? {
    'absent'  => "rm ${_path}.${_generated_suffix}",
    'present' => "postmap ${type}:${_path}",
  }

  exec { "generate ${name}.${_generated_suffix}":
    command     => $generate_cmd,
    path        => $facts['path'],
    #creates    => "${name}.db", # this prevents postmap from being run !
    refreshonly => true,
  }
}
