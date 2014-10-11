ppx_blob
========

OCaml ppx to include a binary blob from a file as a string. Writing [%blob
"filename"] will replace the string with the contents of the file at
compile time. This allows the inclusion of arbitary, possibly compressed, data,
without the need to respect OCaml's lexical conventions.

To build
--------

Run `make` in the top directory. Then run `make` in the `examples` directory.
Now run the `quine` executable.

Credits
-------

A simple modification of the `ppx_getenv` example by Peter Zotov:

http://www.github.com/whitequark/ppx_getenv

