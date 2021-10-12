# Repository

#### 介绍
本地缓存仓库

#### 软件架构

setup.py -- 安装脚本

fix_aar_caches.py -- 修复aar依赖文件pom

mirror.sh -- 从缓存文件生成完整依赖

caches -- 缓存源文件

jcenter -- 完整第三方依赖

#### 安装教程

在build目录下打开命令行，运行 python setup.py
出现 setup local maven repository successful!表示成功

#### 使用说明

可以保持在本地，加快构建速度，不用从远端下载第三方依赖

#### 参与贡献
WuChangkun