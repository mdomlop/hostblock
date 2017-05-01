NAME='hostblock'
PREFIX='/usr'
DESTDIR=''
TEMPDIR := $(shell mktemp -u --suffix .$(NAME))

install:
	install -Dm 755 $(NAME)/$(NAME).sh $(DESTDIR)/$(PREFIX)/bin/$(NAME)
	install -Dm 644 $(NAME)/$(NAME).service $(DESTDIR)/etc/systemd/system/$(NAME).service
	install -Dm 644 $(NAME)/$(NAME).path $(DESTDIR)/etc/systemd/system/$(NAME).path
	install -Dm 644 $(NAME)/$(NAME).timer $(DESTDIR)/etc/systemd/system/$(NAME).timer
	install -Dm 644 LICENSE $(DESTDIR)/$(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 README.md $(DESTDIR)/$(PREFIX)/share/doc/$(NAME)/README

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f /etc/systemd/$(NAME).service
	rm -f /etc/systemd/$(NAME).path
	rm -f /etc/systemd/$(NAME).timer
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
	cp packages/pacman/* ChangeLog $(TEMPDIR)/
	cd $(TEMPDIR); makepkg -dr
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz packages/pacman/
	rm -rf $(TEMPDIR)
	@echo Package done!
	@echo Package is in `pwd`/packages/pacman/

