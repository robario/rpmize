bindir?=/usr/local/bin

install::
	/usr/bin/install -c --mode=0755 --directory $(DESTDIR)$(bindir)
	/usr/bin/install -c --mode=0755 --target-directory=$(DESTDIR)$(bindir) rpmize
