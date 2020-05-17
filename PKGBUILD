# Maintainer: Akshay Nair <phenax5@gmail.com>
pkgname=bsp-layout
pkgver=0.0.2
pkgrel=1
pkgdesc="Dynamic layout management for bspwm with tall, wide, even, tiled, monocle"
arch=('any')
url="https://github.com/phenax/bsp-layout"
license=('MIT')
depends=('bash')
makedepends=('bash')
checkdepends=()
optdepends=()
provides=("$pkgname")
conflicts=("$pkgname")
install=".install"
source=("$url/archive/$pkgver.tar.gz")
md5sums=('SKIP')

package() {
  cd "$pkgname-$pkgver";
	sudo ./install.sh local;
}

