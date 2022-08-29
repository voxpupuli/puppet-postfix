# @summary Creates Postfix hashed "map" files, and builds the corresponding db file
#
# Creates Postfix hashed "map" files. It will create "${name}", and then build
# "${name}.<table type suffix>" using the "postmap" command. The map file can then be referred to
# using postfix::config.
#
# @example Creates a virtual hashmap
#   # This example creates a virtual hashmap in the Postfix config dir
#   # and adds a value into it with the postfix::config type.
#   postfix::hash { 'virtual':
#     ensure => present,
#   }
#   postfix::config { 'virtual_alias_maps':
#     value => 'hash:/etc/postfix/virtual',
#   }
#
# @example Create a sasl_passwd hash from a source file
#   postfix::hash { '/etc/postfix/sasl_passwd':
#     ensure  => 'present',
#     source  => 'puppet:///modules/profile/postfix/client/sasl_passwd',
#   }
#
# @example Create a sasl_passwd hash with contents defined in the manifest
#   postfix::hash { '/etc/postfix/sasl_passwd':
#     ensure  => 'present',
#     content => '#Destination                Credentials\nsmtp.example.com            gssapi:nopassword',
#   }
#
# @param ensure
#   Defines whether the hash map file is present or not. Value can either be present or absent.
#   Example: `absent`.
#
# @param source
#   A string whose value is a location for the source file to be used. This parameter is mutually
#   exclusive with the content parameter, one or the other must be present, but both cannot be present.
#   Example: `puppet:///modules/some/location/sasl_passwd`.
#
# @param content
#   A free form string that defines the contents of the file. This parameter is mutually exclusive
#   with the source parameter.
#   Example: `#Destination                Credentials\nsmtp.example.com            gssapi:nopassword`.
#
define postfix::hash (
  Enum['present', 'absent']                   $ensure  = 'present',
  Variant[Array[String], String, Undef]       $source  = undef,
  Optional[Variant[Sensitive[String],String]] $content = undef,
  Variant[String[4,4], Undef]                 $mode    = '0640',
) {
  include postfix::params

  assert_type(Stdlib::Absolutepath, $name)

  if (!defined(Class['postfix'])) {
    fail 'You must define class postfix before using postfix::config!'
  }

  if $source and $content {
    fail 'You must provide either \'source\' or \'content\', not both'
  }

  postfix::map { $name:
    ensure  => $ensure,
    source  => $source,
    content => $content,
    type    => $postfix::lookup_table_type,
    path    => $name,
    mode    => $mode,
  }
}
