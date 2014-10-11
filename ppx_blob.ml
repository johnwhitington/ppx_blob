open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

let getblob ~loc s =
  try
    let c = open_in_bin s in
      let s = String.init (in_channel_length c) (fun _ -> input_char c) in
        close_in c;
        s
   with
    _ -> raise (Location.Error (Location.error ~loc ("[%blob] could not find or load file " ^ s)))

let getblob_mapper argv =
  (* Our getenv_mapper only overrides the handling of expressions in the default mapper. *)
  { default_mapper with
    expr = fun mapper expr ->
      match expr with
      (* Is this an extension node? *)
      | { pexp_desc =
          (* Should have name "getenv". *)
          Pexp_extension ({ txt = "blob"; loc }, pstr)} ->
        begin match pstr with
        | (* Should have a single structure item, which is evaluation of a constant string. *)
          PStr [{ pstr_desc =
                  Pstr_eval ({ pexp_loc  = loc;
                               pexp_desc = Pexp_constant (Const_string (sym, None))}, _)}] ->
          (* Replace with a constant string with the value from the environment. *)
          Exp.constant ~loc (Const_string (getblob ~loc sym, None))
        | _ ->
          raise (Location.Error (
                  Location.error ~loc "[%blob] accepts a filename as a string, e.g. [%blob \"file.dat\"]"))
        end
      (* Delegate to the default mapper. *)
      | x -> default_mapper.expr mapper x;
  }

let () = register "getblob" getblob_mapper

