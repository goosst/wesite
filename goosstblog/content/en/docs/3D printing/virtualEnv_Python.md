---
author: "goosst"
date: 2020-08-23
title: Virtual environment python
tags:
 - python
 - virtual environment
---

{{% toc %}}

# Intro
Steps to create a virtual python environment using a specific python version (other than the version installed by default).

# Steps
## Install python version

Here using 3.8.4:

```
cd ~
mkdir tmp
cd tmp
wget https://www.python.org/ftp/python/3.8.4/Python-3.8.4.tgz
tar zxfv Python-3.8.4.tgz 
cd Python-3.8.4
./configure --prefix=$HOME/opt/python-3.8.4 --enable-loadable-sqlite-extensions
make
make install
```

## Install virtual environment

```
cd ~/tmp
wget https://files.pythonhosted.org/packages/aa/9d/d7713847ff3f58801045ab2ea5d4b6cdebc4a075b2bdd086f093beb92ecf/virtualenv-20.0.27.tar.gz
tar zxfv
tar zxfv virtualenv-20.0.27.tar.gz 
cd virtualenv-20.0.27
~/opt/python-3.8.4/bin/python3.8 setup.py install
```

## Create environment

```
/home/xxx/opt/python-3.8.4/bin/virtualenv -p /home/xxx/opt/python-3.8.4/bin/python3.8 envfubar
```
