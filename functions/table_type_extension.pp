# @summary Returns the file extension for a table type
# @param type The table type to report on
# @return The file extension of the table type
#
function postfix::table_type_extension(String[1] $type = 'hash') >> Enum['cdb','dir','lmdb','db'] {
  $_generated_suffixes = {
    'cdb'  => 'cdb',
    'dbm'  => 'dir',
    'lmdb' => 'lmdb',
    'sdbm' => 'dir',
  }

  if $type in $_generated_suffixes {
    return $_generated_suffixes[$type]
  } else {
    return 'db'
  }
}
