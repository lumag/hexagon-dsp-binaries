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
	local dstdir="$1/$2/dsp/$3"

	mkdir -p "${dstdir}"
	install -m 0644 "${srcdir}"/* "${dstdir}"

	# FIXME: if the licence ever changes, it has to be read from the WHENCE
	# file.
	install -m 0644 LICENSE.qcom "${dstdir}"
}

# dest target link
do_link() {
	local target="$1/$2"
	local link="$1/$3"

	mkdir -p "`dirname "${link}"`"
	rm -f "${link}"
	ln -sr -T "${target}" "${link}"
}

grep -v '^#\|^$' "${CFG}" | while read verb rest
do
	case ${verb} in
	"Install:" )
		do_install ${DST} ${rest}
		;;
	"Link:" )
		do_link ${DST} ${rest}
		;;
	"*" )
		echo "Unsupported clause ${verb}" >&2
		exit 1
	esac
done
