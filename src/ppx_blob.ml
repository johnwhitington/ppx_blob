open Migrate_parsetree
open Ast_408

let str ?loc ?attrs s = Ast_helper.Exp.constant ?loc ?attrs (Pconst_string (s, None))

let location_errorf ~loc =
  Format.ksprintf (fun err ->
    raise (Location.Error (Location.error ~loc err))
  )

let find_file_path ~loc file_name =
  let dirname = Location.absolute_path loc.Location.loc_start.pos_fname |> Filename.dirname in
  let absolute_path = Filename.concat dirname file_name in
  List.find Sys.file_exists [absolute_path; file_name]

let get_blob ~loc file_name =
  try
    let file_path = find_file_path ~loc file_name in
    let c = open_in_bin file_path in
    let s = String.init (in_channel_length c) (fun _ -> input_char c) in
    close_in c;
    s
  with _ ->
    location_errorf ~loc "[%%blob] could not find or load file %s" file_name

let mapper _config _cookies =
  let default_mapper = Ast_mapper.default_mapper in
  { default_mapper with
    expr = fun mapper expr ->
      match expr with
      | { pexp_desc = Pexp_extension ({ txt = "blob"; loc}, pstr); _} ->
          begin match pstr with
            | PStr [{ pstr_desc =
                        Pstr_eval ({ pexp_loc  = loc;
                                     pexp_desc = Pexp_constant (Pconst_string (file_name, _));
                                     _ }, _);
                        _ }] ->
                str (get_blob ~loc file_name)
            | _ ->
                location_errorf ~loc "[%%blob] accepts a string, e.g. [%%blob \"file.dat\"]"
          end
      | other -> default_mapper.expr mapper other
  }

let () =
  Driver.register ~name:"ppx_blob"
    Versions.ocaml_408
    mapper
