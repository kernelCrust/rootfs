CHECK_GIT_STATUS = git status -s | sed 's/"/|/g'
# ################
# HELP
help:
	@echo 'RUN USAGE: make {unshare.user, unshare.root, chroot.shell} [ROOT_DIR=<new_root>]'
	@echo 'IMAGE USAGE: make {initrd, sqsh} [ROOT_DIR=<new_root>]'

# ################
# Chrooting
unshare.user_shell:
	@scripts/invoke-as.sh --unshare-user \
		$(ROOT_DIR) \
		/bin/sh
unshare.root_shell:
	@scripts/invoke-as.sh --unshare-root \
		$(ROOT_DIR) \
		/bin/sh
unshare.root_init:
	@scripts/invoke-as.sh --unshare-root \
		$(ROOT_DIR) \
		/init
chroot.root_shell:
	@scripts/invoke-as.sh --chroot \
		$(ROOT_DIR) \
		/bin/sh

# ################
# Create images
initrd:
	@scripts/pack-fs.sh --initrd   $(ROOT_DIR)
sqsh:
	@scripts/pack-fs.sh --squashfs $(ROOT_DIR)

# ################
# GIT
pull:
	@git pull
savetogit: git.pushall
	@echo '<--'
git.pushall: git.commitall
	@git push
git.commitall: git.addall
	@echo '--> COMMIT if STATUS allows..'
	@if [ -n "$(shell $(CHECK_GIT_STATUS))" ]; \
		then \
			git commit -m 'saving'; \
		else \
			echo '--- nothing to commit'; \
	fi
git.addall:
	@git add .

