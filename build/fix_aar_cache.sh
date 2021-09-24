#!/bin/bash
SHPATH=$(cd "$(dirname "$0")"; pwd)

SRC_DIR=${SHPATH}/jcenter
CACHE_DIR="${SHPATH}/caches/modules-2/files-2.1/"

${SHPATH}/mirror.sh > /dev/null

DIR_LENGTH=${#SRC_DIR}
if [ `uname` = "Darwin" ]; then
	#mac will add "/"
	DIR_LENGTH=$((DIR_LENGTH+1))
fi
find ${SRC_DIR} -name "*.aar" | while read line
do
	SRC=${line}
	LOCAL_POM=${SRC/.aar/.pom}
	if [ -f ${LOCAL_POM} ]; then
		continue
	fi
	echo "$LOCAL_POM not found"

	URL=${line:${DIR_LENGTH}}
	URL=${URL/.aar/.pom}
	REMOTE_POM=http://maven.aliyun.com/nexus/content/repositories/jcenter/${URL}
	REMOTE_POM_SHA1=${REMOTE_POM}.sha1

	SHA1=`wget -q -O- ${REMOTE_POM_SHA1}`
	SHA1=${SHA1:2} #remove additional \r\n
	echo $SHA1

	#reverse to get it
	FILE=${URL##*/}
	URL=${URL%/*}

	REVISION=${URL##*/}
	URL=${URL%/*}

	MODULE=${URL##*/}
	URL=${URL%/*}

	ORG=${URL}
	echo "ORG=$ORG, MODULE=$MODULE, REVISION=$REVISION, FILE=$FILE"
	#org /->.
	DST=${CACHE_DIR}/${ORG//\//\.}/${MODULE}/${REVISION}/${SHA1}/${FILE}
	echo "$DST"
	mkdir -p `dirname ${DST}`
	if [ ! -f ${DST} ]; then
		wget -O ${DST} ${REMOTE_POM}
	fi
done