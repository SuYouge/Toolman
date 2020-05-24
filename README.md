# Toolman 

学习写脚本。

## 1. [vultr-bash](vultr-bash/README.md)

设计一个可以自动部署vultr服务器的bash脚本。

需要注意的是awk处理的文本有多列的情况，显示起来像空格实际上是换行符，字符串比较的时候要注意

免密码登陆ssh用到了expect脚本。

## 2. [termux-bash](termux-bash/README.md)

手机端`Termux`+`ksweb`+`python-ngrok`配合`sunny+ngrok`的服务搞了个内网穿透（为什么找不到它的英语名）

主要了解一下`termux`这个软件以及`freeBSD`。

## 3. docker-ros

生成ros环境的dockerfile。