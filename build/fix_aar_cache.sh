#!/bin/bash
SHPATH=$(cd "$(dirname "$0")"; pwd)

SRC_DIR=${SHPATH}/jcenter
CACHE_DIR="${SHPATH}/caches/modules-2/files-2.1/"

URLS=( "http://bx-mvn.dataverse.cn:58081/repository/maven-releases/" "http://maven.aliyun.com/nexus/content/repositories/jcenter/")

# ${SHPATH}/mirror.sh > /dev/null

DIR_LENGTH=${#SRC_DIR}
if [ `uname` = "Darwin" ]; then
	#mac will add "/"
	DIR_LENGTH=$((DIR_LENGTH+1))
fi
find ${SRC_DIR} -name "*.aar" | while read line
do
	SRC=${line}
	LOCAL_POM=${SRC/.aar/.pom}
	echo "SRC : $SRC"
	echo "check file : $LOCAL_POM"
	# if [ -f ${LOCAL_POM} ]; then
	# 	continue
	# fi
	echo "$LOCAL_POM not found"

	URL=${line:${DIR_LENGTH}}
	echo "URL : $URL"
	URL=${URL/.aar/.pom}
	FULL_URL=${URL}
	REMOTE_POM=http://maven.aliyun.com/nexus/content/repositories/jcenter/${URL}
	REMOTE_POM_SHA1=${REMOTE_POM}.sha1
	echo "REMOTE_POM : $REMOTE_POM"
	echo "REMOTE_POM_SHA1 : $REMOTE_POM_SHA1"
	SHA1=`wget -q -O- ${REMOTE_POM_SHA1}`
	echo "1 SHA1 : $SHA1"
	SHA1=${SHA1:2} #remove additional \r\n
	echo "2 SHA1 : $SHA1"
	echo $SHA1

	#reverse to get it
	FILE=${URL##*/}
	echo "front URL : $URL"
	URL=${URL%/*}
	echo "back URL : $URL"
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
	I=0
	# for TEST_URL in ${URLS[*]}; do
	# 	if [ -f ${DST} ] && [ -s ${DST} ];then
	# 		break
	# 	fi
	# 	URL_2=${TEST_URL}${FULL_URL}
	# 	echo ”this is $URL_2“
	# 	wget -O ${DST} ${URL_2}
	# done
	# while [ ! -f ${DST} ] || [ ! -s ${DST} ];do
	# 	TEST_URL=${URLS[I]}
	# 	URL_2=${TEST_URL}${FULL_URL}
	# 	wget -O ${DST} ${URL_2}
	# 	I='expr $I + 1'
	# 	if [ $I -eq ${#URLS[*]} ]; then
	# 		break
	# 	fi
	# done
	# if [ ! -f ${DST} ]; then
	# 	echo 'come in 1'
	# 	wget -O ${DST} ${REMOTE_POM}
		# if [ ! -s ${DST} ]; then
		# 	URL_2=http://bx-mvn.dataverse.cn:58081/repository/maven-releases/${FULL_URL}
		# 	echo 'come in 2 URL_2'
		# 	wget -O ${DST} ${URL_2}
		# fi
	# fi
	break
done