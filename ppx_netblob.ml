open Ast_mapper
open Ast_helper
open Asttypes
open Cohttp
open Cohttp_lwt_unix
open Parsetree
open Longident
open Lwt

let getnetblob ~loc s =
  let rec get_body s =
    let uri = Uri.of_string s in
    Client.get uri
    >>= fun (resp, body) ->
    let rcode =
      Response.status resp
      |> Code.code_of_status
    in
    match rcode with
      | 200 ->
          Cohttp_lwt_body.to_string body
      | 301 ->
          (* [MOVED PERMANENTLY], necessary to get this to work with URL
           * shorteners *)
          begin match Header.get (Response.headers resp) "Location" with
            | Some s' ->
                Printf.printf
                  "WARNING: received response code 301 MOVED PERMANENTLY to \
                  \"%s\" when requesting resource \"%s\", this is probably a \
                  security vulnerability.\n"
                  s'
                  s;
                get_body s'
            | None ->
                raise (Location.Error (
                  Location.error ~loc
                    "ERROR: [%netblob] received a 301 (moved permanently) \
                    response code but was not supplied with a Location header"))
          end
      | n ->
          raise (Location.Error (
            Location.error
              ~loc
              (Printf.sprintf
                "HTTP error %d, [%%netblob] could not find or load resource %s"
                n s)))
  in
  Lwt_main.run (get_body s)

let getnetblob_generator ~loc s =
  (* start by testing to see if [s] is a reachable resource at compile-time *)
  let () =
    try
      ignore(getnetblob ~loc s)
    with _ ->
      Printf.printf
        "WARNING: ppx_netblob: there was a problem trying to fetch the resource \
        \"%s\" at compile-time, this could be a warning that it won't be \
        available at runtime, either.\n"
        s
  in
  let s = Exp.constant (Const_string (s, None)) in
  [%expr
    let open Cohttp in
    let open Cohttp_lwt_unix in
    let open Lwt in
    let rec do_req ~get s =
      let uri = Uri.of_string s in
      let uri = List.fold_left (fun acc (name, value) -> Uri.add_query_param acc (name, [value])) uri get in
      Client.get uri
      >>= fun (resp, body) ->
      let rcode =
        Response.status resp
        |> Code.code_of_status
      in
      match rcode with
        | 200 ->
            Cohttp_lwt_body.to_string body
        | 301 ->
            (* [MOVED PERMANENTLY], necessary to get this to work with URL
             * shorteners *)
            begin match Header.get (Response.headers resp) "Location" with
              | Some s' ->
                  Lwt_io.printf
                    "WARNING: the ppx_netblob runtime received response code \
                    301 MOVED PERMANENTLY to \"%s\" when requesting resource \
                    \"%s\", this is probably a security vulnerability.\n"
                    s' s
                  >>= fun () ->
                  do_req ~get s'
              | None ->
                  raise (
                    Failure (
                      Printf.sprintf
                        "ERROR: [%%netblob] received a 301 (moved permanently) \
                        response code while trying to fetch the resource at \
                        \"%s\" but was not supplied with a Location header."
                        s))
            end
        | n ->
            raise (
              Failure (
                Printf.sprintf
                  "HTTP error %d, [%%netblob] could not find or load resource %s"
                  n [%e s]))
    in
    fun ?(get = []) () ->
      do_req ~get [%e s]]

let netblob_mapper argv =
  (* Our netblob_mapper only overrides the handling of expressions in the
   * default mapper. *)
  { default_mapper with
    expr = fun mapper expr ->
      match expr with
      (* Is this an extension node? *)
      | { pexp_desc =
          (* Should have name "netblob". *)
          Pexp_extension ({ txt = "netblob"; loc }, pstr)} ->
        let error () =
          raise (
            Location.Error (
              Location.error ~loc
                "[%netblob] accepts a URL as a string, e.g. \
                [%netblob \"https://goo.gl/nTD9Oc\"] or a structure such as \
                [%netblob {runtime = \"https://goo.gl/nTD9Oc\"}] to instead \
                generate a function of the type [?get ()] which may be used at \
                runtime to retrieve the resource."))
        in
        begin match pstr with
        | (* Could also have a single structure item which is the evaluation of a constant structure of the form [{ runtime = "URL"}] *)
          PStr [{ pstr_desc = Pstr_eval ({ pexp_loc = loc; pexp_desc = Pexp_record ([{txt = Lident "runtime"}, value], _)}, _) }] ->
            let () = Printf.printf "found structure instance" in
            begin match Ast_convenience.get_str value with
            | Some sym ->
                with_default_loc loc (fun () -> getnetblob_generator ~loc sym)
            | None -> error ()
            end
        | (* Should have a single structure item, which is evaluation of a constant string. *)
          PStr [{ pstr_desc = Pstr_eval ({ pexp_loc = loc } as expr, _) }] ->
            begin match Ast_convenience.get_str expr with
            | Some sym ->
              (* Replace with the contents retrieved from the URL. *)
              (* Have to use Ast_helper.with_default_loc to pass the location to Ast_convenience.str until
                 https://github.com/alainfrisch/ppx_tools/pull/38 is released. *)
              with_default_loc loc (fun () -> Ast_convenience.str (getnetblob ~loc sym))
            | None -> error ()
            end
        | _ -> error ()
        end
      (* Delegate to the default mapper. *)
      | x -> default_mapper.expr mapper x;
  }

let () = register "netblob" netblob_mapper

