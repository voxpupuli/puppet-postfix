(*
Module: Postfix_Canonical
  Parses /etc/postfix/*canonical

Author: James Brown <jbrown@uber.com> based on work by Raphael Pinson <raphael.pinson@camptocamp.com>

About: Reference
  This lens tries to keep as close as possible to `man 5 canonical` where possible.

About: License
   This file is licenced under the LGPL v2+, like the rest of Augeas.

About: Lens Usage
   To be documented

About: Configuration files
   This lens applies to /etc/postfix/*canonical. See <filter>.

About: Examples
   The <Test_Postfix_Canonical> file contains various examples and tests.
*)

module Postfix_Canonical =

autoload xfm

(* Variable: space_or_eol_re *)
let space_or_eol_re = /([ \t]*\n)?[ \t]+/

(* View: space_or_eol *)
let space_or_eol (sep:regexp) (default:string) =
  del (space_or_eol_re? . sep . space_or_eol_re?) default 

(* View: word *)
let word = store /[A-Za-z0-9@\*.+-]+/

(* View: comma *)
let comma = space_or_eol "," ", "

(* View: destination *)
let destination = [ label "destination" . word ]

(* View: record *)
let record = [ label "pattern" . word
     . space_or_eol Rx.space " " . destination
     . Util.eol ]

(* View: lns *)
let lns = (Util.empty | Util.comment | record)*

(* Variable: filter *)
let filter = incl "/etc/postfix/*canonical"

let xfm = transform lns filter
