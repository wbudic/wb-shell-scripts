## Compile installing vim
```
sudo apt install libtool-bin libncurses-dev libxt-dev -y

cd ~/dev
git clone https://github.com/vim/vim.git
cd vim/src
./configure --with-features=huge --enable-multibyte --enable-perlinterp=yes --enable-cscope
make
make test
sudo make install
```