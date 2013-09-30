install: install-bin install-dot

install-bin:
	ln -s $$PWD ~/bin

install-dot:
	ln -s $$PWD/dot.git-prompt.sh ~/.git-prompt.sh
	ln -s $$PWD/dot.gitconfig ~/.gitconfig
	ln -s $$PWD/dot.gitignore ~/.gitignore
	ln -s $$PWD/dot.tmux.conf ~/.tmux.conf
	ln -s $$PWD/dot.zshrc ~/.zshrc
	ln -s $$PWD/dot.zshrc-base ~/.zshrc-base
