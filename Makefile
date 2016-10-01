OCAMLFIND_IGNORE_DUPS_IN = $(shell ocamlfind query compiler-libs)
export OCAMLFIND_IGNORE_DUPS_IN

SOURCES = ppx_netblob.ml

PACKS = ppx_tools cohttp.lwt lwt

RESULT = ppx_netblob

OCAMLNCFLAGS = -g -w -3
OCAMLBCFLAGS = -g -w -3
OCAMLLDFLAGS = -g

all : native-code

install :
	ocamlfind install ppx_netblob META ppx_netblob

-include OCamlMakefile

