install:
	@echo "Installing git ommix !"
	install -Dm755 git-ommix /bin/git-ommix
	install -Dm644 functions /usr/share/git-ommix/functions
	install -Dm644 example.conf /etc/gitommix.conf

uninstall:
	@echo "Uninstalling…"
	rm -rf /bin/git-ommix
	rm -rf /usr/share/git-ommix
