DUNE ?= dune

all:
	$(DUNE) build @install @example

test:
	$(DUNE) runtest

clean:
	rm -rf _build

.PHONY: test all clean
