#! /bin/sh
# SPDX-License-Identifier: MIT
#
# Install DSP shell and libraries

set -e

if [ "$#" -ne 2 -o "$1" = "-h" -o "$1" = "--help" ]
then
	echo "Usage: $0 config.txt <destdir>" >&2
	exit 1
fi

CFG="$1"
DST="$2"

if ! [ -r "${CFG}" ]
then
	echo "config ${CFG} is unreadable" >&2
	exit 1
fi

mkdir -p "${DST}"

# dest subdir DSP QC_IMAGE_VERSION_STRING
# FIXME: maybe install only a fixed set of files
do_install() {
	local srcdir="$2/$4"
	local dstdir="$1/$2/$4"

	mkdir -p "${dstdir}"
	install -m 0644 "${srcdir}"/* "${dstdir}"
}

grep -v '^#\|^$' "${CFG}" | while read verb rest
do
	case ${verb} in
	"Install:" )
		do_install ${DST} ${rest}
		;;
	"Link:" )
		# ignore
		;;
	"*" )
		echo "Unsupported clause ${verb}" >&2
		echo 
	esac
done

grep ^Licence WHENCE | cut -d ' ' -f 2 | while read licence
do
	[ -r "${DST}/$licence" ] || install -m 0644 $licence "${DST}"
done

cp -r scripts/ Makefile config.txt ${DST}

./scripts/filter_whence.py config.txt WHENCE ${DST}/WHENCE
