(*  "https://goo.gl/nTD9Oc" *)

let () =
  let open Lwt in
  Lwt_main.run (
    [%netblob { runtime = "https://goo.gl/nTD9Oc" }] ~get:[] ()
    >>= fun s ->
    Lwt_io.printl s)
