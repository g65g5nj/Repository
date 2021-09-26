#!/usr/bin/python
#coding=utf-8

import os,subprocess,requests
from requests.models import Response

localDir = os.path.split(os.path.realpath(__file__))[0]
os.chdir(localDir)

SRC_DIR="{0}/jcenter".format(localDir)
CACHE_DIR="{0}/caches/modules-2/files-2.1/".format(SRC_DIR)

URLS=[
    "http://bx-mvn.dataverse.cn:58081/repository/maven-releases/",
    "http://maven.aliyun.com/nexus/content/repositories/jcenter/",
    'http://developer.huawei.com/repo/',
    "https://s3.amazonaws.com/moat-sdk-builds",
    "https://adcolony.bintray.com/AdColony",
    'https://jitpack.io',
    'https://chartboostmobile.bintray.com/Chartboost',
    'https://artifact.bytedance.com/repository/pangle',
    'https://android-sdk.is.com/'
]

process = subprocess.Popen(args=[
    "find",
    SRC_DIR,
    "-name",
    "*.aar"
],shell=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
err = process.stderr.read()
result = process.stdout.readlines()
for i in range(len(result)):
    filename = result[i].decode('utf-8')
    
    LOCAL_POM = filename.replace(".aar",".pom")
    LOCAL_POM = LOCAL_POM.replace("\n","")
    LOCAL_POM_DST = LOCAL_POM
    LOCAL_POM = LOCAL_POM[len(SRC_DIR)+1:]

    END_URL = LOCAL_POM
    REAL_EXIST = False
    if os.path.exists(LOCAL_POM):
        with open(LOCAL_POM) as f:
            texts = f.read()
            if len(texts) == 0:
                pass
                # print("{0} is empty".format(LOCAL_POM))
            else:
                REAL_EXIST = True
                # print("{0} is real".format(LOCAL_POM))
            f.close()
    else:
        pass
        # print("{0} is not exists".format(LOCAL_POM))
    if REAL_EXIST:
        continue
    FILE = LOCAL_POM[LOCAL_POM.rfind("/")+1:]
    LOCAL_POM = LOCAL_POM[:LOCAL_POM.rfind("/")]

    REVISION = LOCAL_POM[LOCAL_POM.rfind("/")+1:]
    LOCAL_POM = LOCAL_POM[:LOCAL_POM.rfind("/")]

    MODULE = LOCAL_POM[LOCAL_POM.rfind("/")+1:]

    ORG = LOCAL_POM[:LOCAL_POM.rfind("/")]
    ORG = ORG.replace("/",".")
    # print("ORG : {0}, FILE : {1}, REVISION : {2}".format(ORG,FILE,REVISION))

    for i in range(len(URLS)):
        host = URLS[i]
        fullUrl = host + END_URL
        # print("fullUrl : {0} LOCAL_POM_DST : {1}".format(fullUrl,LOCAL_POM_DST))
        try:
            response = requests.get(url=fullUrl)
            response.raise_for_status()
            with open(LOCAL_POM_DST,mode="w+") as f:
                print(response.text)
                f.write(response.text)
                f.close()
        except Exception as e:
            # print(e)
            pass