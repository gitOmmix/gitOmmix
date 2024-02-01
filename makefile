install:
	@echo "Installing git ommix !"
	install -m755 git-ommix /usr/bin/git-ommix
	install -m644 example.conf /etc/gitommix.conf

	mkdir -p /usr/share/git-ommix
	install -m644 functions /usr/share/git-ommix/functions

	[ -d /usr/share/bash-completion/completions ] && install -m644 gitommix-completions /usr/share/bash-completion/completions/git-ommix

uninstall:
	@echo "Uninstalling…"
	rm -rf /usr/bin/git-ommix
	rm -rf /usr/share/git-ommix
	[ -d /usr/share/bash-completion/completions ] && rm -rf /usr/share/bash-completion/completions/git-ommix
