ppx_blob
========

OCaml ppx to include a binary blob from a file as a string. Writing `[%blob
"filename"]` will replace the string with the contents of the file at
compile time. This allows the inclusion of arbitary, possibly compressed, data,
without the need to respect OCaml's lexical conventions.

The filename can be relative to either the source file where `[%blob]` appears, or relative to the current working directory. If both files exist, the former takes precedence.

To build
--------

Requires OCaml 4.02 or above.

Run `make` in the top directory. Then run `make` in the `examples` directory.
Now run the `quine` executable.

To install
----------

Run `make install` in the top directory once `make` has been run.

Integration with build systems
------------------------------

**dune**

Add `(preprocessor_deps filename)` to your filename stanza. See https://github.com/johnwhitington/ppx_blob/tree/master/test for an example. This will make sure the file is copied to the build directory and therefore visible to ppx_blob`.
