0.9.0 2024-07-28
---------------------------------

- Absolute paths are no longer concatenated with the source directory to
  form a blob candidate path: they are only treated as absolute paths.
- Minor robustness improvements (reminder: this happens at build time):
  - Reading is done in one pass (instead of checking for existence first).
  - Only the first good path is queried (instead of both).
  - Better I/O error handling.

0.8.0 2024-04-04
---------------------------------

- Fix the handling of paths relative to the source file in environments with
  `(lang dune 3.0)` (#24).

0.7.2 2020-11-24
---------------------------------

- Port to ppxlib (#20).

0.7.1 2020-09-15
---------------------------------

- Use `Ast_411` from ocaml-migrate-parsetree for compatibility with new OCaml syntax (#19).

0.7.0 2020-03-24
---------------------------------

- Use `Ast_408` from ocaml-migrate-parsetree for compatibility with new OCaml syntax (#17).

0.6 2019-12-31
---------------------------------

- Migrate to dune and dune-release

0.4 2018-02-10
---------------------------------

- Check if file exists relative to working directory (#9)

0.3 2017-08-22
---------------------------------

- Migrate to jbuilder and ocaml-migrate-parsetree (#7)

0.2 2016-04-18
---------------------------------

- Merge pull request #3 from aantron/updates
- Port to 4.03 and some fixes

0.1 2014-10-11
---------------------------------

- Version 0.1 for opam
