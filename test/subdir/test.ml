let suite = [
    ("path relative to source file", `Quick, fun () ->
      Alcotest.(check string) "file contents" "test/subdir/test_file\n" [%blob "test_file"]
    );

    ("path relative to source file (parent dir)", `Quick, fun () ->
      Alcotest.(check string) "file contents" "test/test_file\n" [%blob "../test_file"]
    );
  ]

let () =
  Alcotest.run "ppx_blob" [
    "basic", suite
  ]
