# **vultr-bash**

脚本详解文章链接在[这里](http://mecha-su.cn/2019/12/21/toolman-1/)。

## 1. **准备工作**

### 1.1 启用win10下的linux

参考[baidu经验](https://jingyan.baidu.com/article/c85b7a64a56c7f003aac954f.html)配置一个可以在win10下运行的linux系统

等待过程可以开展下面的配置

### 1.2 配置API-KEY

进入Vultr的[API](https://my.vultr.com/settings/#settingsapi)设置界面

在**Personal Access Token**中启用API，并将API-KEY复制下来

在**Access Control**中输入你所在的ip（可以baidu`ip`得到）以指定使用API-KEY的访问权限，输入类似`192.168.1.1/32`后点击Add。

### 1.3 安装依赖

安装依赖:

`sudo apt-get install expect`  
`sudo apt-get install git`

### 1.4 准备的最后一步（安装并运行脚本）

访问[脚本下载地址](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/SuYouge/Toolman/tree/master/vultr-bash)解压后放在某个根目录下（比如D盘，这样比较方便）

假设已经解压在`d盘`，在linux的终端下输入`cd /mnt/d/vultr-bash` （cd去指定目录）

首次运行时输入`./vultr-bash.sh -init`并按照提示将之前在vultr配置的API-KEY复制下来即可。

建议首次运行按交互式模式，可以看到脚本的运行流程``

### 1.5 后续访问

每次通过`cd`跳转后执行或者直接运行`cd ./mnt/d/vultr-bash/vultr-bash --参数`即可，这条指令假设你将文件夹解压在`d盘`。

## 2. **使用说明**

### **-init**

检查是否有config文件，如果有则显示内容，如果没有则提示输入API-KEY

### **不带参数**

交互式布置

### **-auto**

自动布置一个miami10刀的ubuntu18.04LTS（如果已有一个服务器无论配置如何就在它上面运行后续）。

### **-interact**

交互式布置服务器

### **-d (-destroy)**

`-d`或者`-destroy`会销毁你当前所有的服务器（所以希望你只开一个，一个以上的情况暂时也没有测试）

## 3. **注意事项**

脚本写得太糙且简单所以建议运行时不要终止脚本，**至少在等待服务器开启的倒计时阶段不要终止脚本**，也不会有什么严重后果就是要等一段时间再运行auto模式的脚本否则会重复申请相同的服务器（没有试过，估计会再发一个服务器给你）

**不建议用这个脚本布置一个以上的服务器**，一定会发生未知bug