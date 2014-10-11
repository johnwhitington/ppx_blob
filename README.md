ppx_blob
========

OCaml ppx to include binary data from a file as a string. Writing [%blob "filename"] will replace the string with the contents of the file at compile-time.

To build
--------

Run `make` in the top directory. Then run `make` in the `examples` directory. Now run the `quine` executable.

Credits
-------

A simple modification of the ppx_getenv example by Peter Zotov.

