SOURCES = ppx_blob.ml

PACKS = ppx_tools 

RESULT = ppx_blob

OCAMLNCFLAGS = -g -w -3
OCAMLBCFLAGS = -g -w -3
OCAMLLDFLAGS = -g

all : native-code

-include OCamlMakefile

