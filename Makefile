#
# This Makefile is not called from Opam but only used for
# convenience during development
#

JB 	= dune

all:
	$(JB) build

install:
	$(JB) install

clean:
	$(JB) clean

%:
	$(JB) build $@

test:
	$(JB) runtest
