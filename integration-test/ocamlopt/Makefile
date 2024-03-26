.PHONY: run
run:
	ocamlopt -ppx "$(shell ocamlfind query ppx_blob)/ppx.exe --as-ppx" \
		-o foo.native \
		src/foo.ml
	./foo.native

.PHONY: clean
clean:
	rm -f foo.native src/foo.{o,cmx,cmi}
