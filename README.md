ppx_netblob
========

OCaml ppx to include a binary blob from a URL as a string. Writing `[%netblob
"url"]` will replace the string with the result of sending an HTTP GET
request to `url` at compile time. This allows the inclusion of arbitary,
possibly compressed, data, without the need to respect OCaml's lexical
conventions. It should be noted that `ppx_netblob` will interpret HTTP 301
responses, following the URL given in the response's `Location` header, which
is a possible security vulnerability (and emitting a warning). I would advise
against using this in production code, since I haven't done a huge amount of
research into how well `cohttp` supports HTTPS, so I'm not sure if this is
subject to security downgrading attacks.

To build
--------

Requires OCaml 4.02 or above.

Run `make` in the top directory. Then run `make` in the `examples` directory.
Now run the `quine` executable.

To install
----------

Run `make install` in the top directory once `make` has been run.
