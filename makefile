NAME='hostblock'
PREFIX='/usr'
DESTDIR=''
TEMPDIR := $(shell mktemp -u --suffix .$(NAME))

install:
	install -Dm 755 $(NAME)/$(NAME).sh $(DESTDIR)/$(PREFIX)/bin/$(NAME)
	install -Dm 644 $(NAME)/$(NAME).service $(DESTDIR)/$(PREFIX)/lib/systemd/system/$(NAME).service
	install -Dm 644 $(NAME)/$(NAME).path $(DESTDIR)/$(PREFIX)/lib/systemd/system/$(NAME).path
	install -Dm 644 $(NAME)/$(NAME).timer $(DESTDIR)/$(PREFIX)/lib/systemd/system/$(NAME).timer
	install -Dm 644 LICENSE $(DESTDIR)/$(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 README.md $(DESTDIR)/$(PREFIX)/share/doc/$(NAME)/README

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(PREFIX)/lib/systemd/system/$(NAME).service
	rm -f $(PREFIX)/lib/systemd/system/$(NAME).path
	rm -f $(PREFIX)/lib/systemd/system/$(NAME).timer
	rm -rf $(PREFIX)/share/licenses/$(NAME)/
	rm -rf $(PREFIX)/share/doc/$(NAME)/

clean:
	rm -f man/*/$(NAME).gz
	rm -f packages/pacman/$(NAME)-*.pkg.tar.xz

togit: clean
	git add .
	git commit -m "Updated from makefile"
	git push origin


pacman: clean
	mkdir $(TEMPDIR)
	tar cf $(TEMPDIR)/$(NAME).tar ../$(NAME)
	cp packages/pacman/local/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz .
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz

pacman-remote: clean
	mkdir $(TEMPDIR)
	cp packages/pacman/git/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz .
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz
