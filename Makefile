# Adjust this path to point to the sources of your popc installation
POPCBASE?=
PREFIX?=/usr/local/bin

TAR=pop-linker_0.1b
EXEC=pop-link

.PHONY: clean install all

all: pop-link

pop-link: main.cc
	popcc -I$(POPCBASE)/lib -I$(POPCBASE)/include -o $(EXEC) main.cc \
	$(POPCBASE)/lib/JobMgr.ph \
	$(POPCBASE)/lib/JobMgr.cc \
	$(POPCBASE)/lib/paroc_service_base.ph \
	$(POPCBASE)/lib/service_base.cc

install: pop-link
	mv pop-link $(PREFIX)/pop-link

$(TAR).tar.gz: main.cc LICENSE README Makefile
	cd .. ; tar -czf $(TAR).tar.gz $$(basename $(abspath .))
	mv ../$(TAR).tar.gz .

dist: $(TAR).tar.gz

test:
	echo $$(basename $(abspath .))

clean:
	rm -rf $(EXEC) *.o *.tar.gz

