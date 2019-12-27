DUNE ?= dune

all:
	$(DUNE) build @install @example

test:
	$(DUNE) runtest

clean:
	rm -rf _build

tag:
	dune-release tag

distrib:
	dune-release distrib

publish:
	dune-release publish


.PHONY: test all clean tag distrib publish
