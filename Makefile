DESTDIR=
prefix=/usr/local

install:
	mkdir -p $(DESTDIR)$(prefix)/bin
	cp -v git* svn* new-* $(DESTDIR)$(prefix)/bin

