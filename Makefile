# bsp-layout

VERSION = 0.0.5

PREFIX = ${DESTDIR}/usr/local
MANPREFIX = ${PREFIX}/share/man
SRCPREFIX = ${DESTDIR}/usr/lib

BINARY_PATH = ${PREFIX}/bin
MAN_PATH = ${MANPREFIX}/man1
SRC_PATH = ${SRCPREFIX}/bsp-layout

MANPAGE = ${MAN_PATH}/bsp-layout.1

uninstall:
	rm -f ${BINARY_PATH}/bsp-layout ${MAN_PATH}/bsp-layout.1
	rm -rf ${SRC_PATH}

install: uninstall
	mkdir -p ${BINARY_PATH} ${SRC_PATH} ${MAN_PATH}
	cp -r src/* ${SRC_PATH}/ # Source files
	sed "s/{{VERSION}}/${VERSION}/g" < src/layout.sh > ${SRC_PATH}/layout.sh # Update version
	sed "s/{{VERSION}}/${VERSION}/g" < bsp-layout.1 > ${MANPAGE} # Manpage
	chmod 644 ${MANPAGE} # Manpage permission
	chmod +x ${SRC_PATH}/layouts/*.sh
	chmod +x ${SRC_PATH}/layout.sh
	ln -s ${SRC_PATH}/layout.sh ${BINARY_PATH}/bsp-layout # Create bin
	echo "Unstalled bsp-layout"

.PHONY: install uninstall
