# ppx_blob

This is an OCaml PPX to include a binary blob from a file as a string. Writing
`[%blob "filename"]` will replace the string with the contents of the file at compile
time. This allows the inclusion of arbitrary, possibly compressed, data, without the need
to respect OCaml's lexical conventions.

The filename can be relative to either the source file where `[%blob]` appears, or
relative to the current working directory. If both files exist, the former takes
precedence.

## Integration with build systems

### Dune

Add `(preprocessor_deps (file path/to/file))` to your library or executable stanza. See
[test/dune](test/dune) for an example. This will make sure the file is copied to the build
directory and therefore visible to `ppx_blob`.

## Development

Requirements:

- OCaml 4.08+
- Packages: see [ppx_blob.opam](ppx_blob.opam).

Run `make` and `make test`.
