let suite = [
  ("relative to source file: root", `Quick, fun () ->
    Alcotest.(check string) "blob" "included-root\n" [%blob "../root.inc"]
  );
  ("relative to source file: subdir", `Quick, fun () ->
    Alcotest.(check string) "blob" "included-sub\n" [%blob "../subdir/sub.inc"]
  );
  ("relative to build directory: root", `Quick, fun () ->
    Alcotest.(check string) "blob" "included-root\n" [%blob "test/root.inc"]
  );
  ("relative to build directory: subdir", `Quick, fun () ->
    Alcotest.(check string) "blob" "included-sub\n" [%blob "test/subdir/sub.inc"]
  );
]

let () =
  Alcotest.run "ppx_blob" [
    "basic", suite
  ]
