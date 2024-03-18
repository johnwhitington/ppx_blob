let check ~path ~expected ~actual =
  let actual = String.trim actual in
  if String.equal expected actual then (
    Printf.printf "PASS: path: %s\n" path;
    Ok ())
  else (
    Printf.printf "FAIL: path: %s, expected: %s, actual: %s\n" path expected
      actual;
    Error ())

let () =
  if
    List.exists Result.is_error
      [
        (* Path relative to this file *)
        check ~path:"../root.inc" ~expected:"included-root"
          ~actual:[%blob "../root.inc"];
        check ~path:"src.inc" ~expected:"included-src" ~actual:[%blob "src.inc"];
        (* Path relative to build directory *)
        check ~path:"root.inc" ~expected:"included-root"
          ~actual:[%blob "root.inc"];
        check ~path:"src/src.inc" ~expected:"included-src"
          ~actual:[%blob "src/src.inc"];
        (* Ambiguous path *)
        check ~path:"common.inc" ~expected:"included-common-src"
          ~actual:[%blob "common.inc"];
        check ~path:"../common.inc" ~expected:"included-common-root"
          ~actual:[%blob "../common.inc"];
        (* Absolute path *)
        check ~path:"/etc/hostname" ~expected:"included-hostname"
          ~actual:[%blob "/etc/hostname"];
      ]
  then exit 1
