# Adjust this path to point to the sources of your popc installation
POPCBASE?=/usr/local/popc
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
	rm -rf linker
	mkdir linker
	cp main.cc linker
	cp LICENSE linker
	cp README linker
	cp Makefile linker
	tar -czf $(TAR).tar.gz linker
	rm -rf linker

dist: $(TAR).tar.gz

test:
	echo $$(basename $(abspath .))

clean:
	rm -rf $(EXEC) *.o *.tar.gz

