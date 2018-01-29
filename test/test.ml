let suite = [
  ("path relative to source file", `Quick, fun () ->
    Alcotest.(check string) "file contents" "foo\n" [%blob "test_file"]
  );
  ("path relative to working directory", `Quick, fun () ->
    Alcotest.(check string) "file contents" "foo\n" [%blob "../../test/test_file"]
  )
]

let () =
  Alcotest.run "ppx_blob" [
    "basic", suite
  ]
