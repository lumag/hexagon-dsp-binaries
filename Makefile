# SPDX-License-Identifier: MIT

prefix ?= /usr
DSPDIR = ${prefix}/share/qcom

all:

install:
	./scripts/install.sh config.txt ${DESTDIR}/${DSPDIR}
