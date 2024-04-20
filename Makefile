.PHONY: all
all:
	dune build @install @example

.PHONY: test
test:
	dune runtest

.PHONY: clean
clean:
	dune clean

.PHONY: tag
tag:
	dune-release tag

.PHONY: distrib
distrib:
	dune-release distrib

.PHONY: publish
publish:
	dune-release publish
