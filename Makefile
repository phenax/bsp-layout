# bsp-layout

VERSION = 0.0.5

PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man
SRCPREFIX = ${PREFIX}/lib

BINARY_PATH = ${DESTDIR}${PREFIX}/bin
MAN_PATH = ${DESTDIR}${MANPREFIX}/man1
SRC_PATH = ${DESTDIR}${SRCPREFIX}/bsp-layout

MANPAGE = ${MAN_PATH}/bsp-layout.1

uninstall:
	rm -f ${BINARY_PATH}/bsp-layout ${MAN_PATH}/bsp-layout.1
	rm -rf ${SRC_PATH}
	echo "Removed bsp-layout source files"

install:
	mkdir -p ${BINARY_PATH} ${SRC_PATH} ${MAN_PATH}
	cp -rf src/* ${SRC_PATH}/ # Source files
	cp src/layout.sh layout.sh.tmp
	sed "s|{{VERSION}}|${VERSION}|g" layout.sh.tmp > ${SRC_PATH}/layout.sh # Update version
	cp -f ${SRC_PATH}/layout.sh layout.sh.tmp
	sed "s|{{SOURCE_PATH}}|${SRC_PATH}|g" layout.sh.tmp > ${SRC_PATH}/layout.sh # Update source path
	rm layout.sh.tmp
	sed "s|{{VERSION}}|${VERSION}|g" bsp-layout.1 > ${MANPAGE} # Manpage
	chmod 644 ${MANPAGE} # Manpage permission
	chmod 755 ${SRC_PATH}/layouts/*.sh
	chmod 755 ${SRC_PATH}/layout.sh
	ln -sf ${SRC_PATH}/layout.sh ${BINARY_PATH}/bsp-layout # Create bin
	echo "Installed bsp-layout"

.PHONY: install uninstall
