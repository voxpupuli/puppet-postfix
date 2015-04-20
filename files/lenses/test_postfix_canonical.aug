(*
Module: Test_Postfix_Canonical
  Provides unit tests and examples for the <Postfix_Canonical> lens.
*)

module Test_Postfix_Canonical =

(* View: conf *)
let conf = "# a comment
user@domain.com @domain
@otherdomain  @otherotherdomain
someuser  Full.Some.User
"

(* Test: Postfix_Canonical.lns *)
test Postfix_Canonical.lns get conf =
  { "#comment" = "a comment" }
  { "pattern" = "user@domain.com"
    { "destination" = "@domain" }
  }
  { "pattern" = "@otherdomain"
    { "destination" = "@otherotherdomain" }
  }
  { "pattern" = "someuser"
    { "destination" = "Full.Some.User" }
  }
