include ::augeas

if $::needs_postfix_class {
  include ::postfix
}
