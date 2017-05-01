exe='hostblock.sh'
service='hostblock.service'

install:
	install -m 755 $(exe) /usr/bin/
	install -m 644 $(service) /etc/systemd/system/
uninstall:
	rm /usr/bin/$(exe)
	rm /etc/systemd/system/$(service)
