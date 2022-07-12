let suite = [
  ("path relative to source file", `Quick, fun () ->
    Alcotest.(check string) "file contents" "foo\n" [%blob "test_file"]
  );
  ("path relative to source file (subdir)", `Quick, fun () ->
    Alcotest.(check string) "file contents" "subdir foo\n" [%blob "subdir/test_file"]
  );
  ("path relative to source file (parent dir)", `Quick, fun () ->
    Alcotest.(check string) "file contents" "parent foo\n" [%blob "../test_file"]
  );
]

let () =
  Alcotest.run "ppx_blob" [
    "basic", suite
  ]
