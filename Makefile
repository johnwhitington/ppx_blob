JBUILDER ?= jbuilder

all:
	$(JBUILDER) build @install

test:
	$(JBUILDER) runtest

clean:
	rm -rf _build

.PHONY: test all clean
