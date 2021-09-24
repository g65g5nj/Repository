#!/bin/bash
#use .gradle/caches/modules-2/files-2.1/ to create jcenter
SHPATH=$(cd "$(dirname "$0")"; pwd)
DIR="${SHPATH}/caches/modules-2/files-2.1/"
DIR_LENGTH=${#DIR}
if [ `uname` = "Darwin" ]; then
	#mac will add "/"
	DIR_LENGTH=$((DIR_LENGTH+1))
fi
rm -rf ${SHPATH}/jcenter/*
find ${DIR} -type f | grep -Ev "DS_Store" | while read line
do
	SRC=${line}
	URL=${line:${DIR_LENGTH}}

	ORG=${URL%%/*}
	URL=${URL#*/}

	MODULE=${URL%%/*}
	URL=${URL#*/}

	REVISION=${URL%%/*}
	URL=${URL#*/}

	SHA1=${URL%%/*}
	URL=${URL#*/}

	FILE=${URL}
	#echo "ORG=$ORG, MODULE=$MODULE, REVISION=$REVISION, SHA1=$SHA1, FILE=$FILE"

	DST=${SHPATH}/jcenter/${ORG//.//}/${MODULE}/${REVISION}/${FILE}
	echo "$DST"
	mkdir -p `dirname ${DST}`
	if [ ! -f ${DST} ]; then
		cp -a ${SRC} ${DST}
	fi
done