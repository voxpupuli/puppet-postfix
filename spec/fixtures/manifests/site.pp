include ::augeas

if $::needs_postfix_class {
  include ::postfix
}

if $::needs_postfix_class_with_params {
  class { '::postfix':
    relayhost     => 'foo',
    mydestination => 'bar',
    mynetworks    => 'baz',
  }
}
