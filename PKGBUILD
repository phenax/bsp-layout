# Maintainer: Akshay Nair <phenax5@gmail.com>
pkgname=bsp-layout
pkgver=0.0.5
pkgrel=2
pkgdesc="Dynamic layout management for bspwm with tall, wide, even, tiled, monocle"
arch=('any')
url="https://github.com/phenax/bsp-layout"
license=('MIT')
depends=('bash' 'bc')
makedepends=('bash' 'git')
checkdepends=()
optdepends=()
provides=("$pkgname")
conflicts=("$pkgname")
install=".install"
source=("$url/archive/$pkgver.tar.gz")
md5sums=('SKIP')

package() {
  cd "$pkgname-$pkgver";
  ./install.sh local;
}

