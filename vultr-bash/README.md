# vultr-bash

详解文章链接在[这里](http://mecha-su.cn/2019/12/21/toolman-1/)。

server_list
返回格式：
* DCID :  ***  
* SUBID :  *********  
* VPSPLANID :  ***  
* cost_per_month :  10.00  
* default_password :  ****************  
* main_ip :  **************  
* os :  Ubuntu 18.04 x64  
* power_status :  running  
* server_state :  ok  
* status :  active  
* v6_main_ip : 

需要注意的是awk处理的文本有多列的情况，显示起来像空格实际上是换行符，字符串比较的时候要注意

免密码登陆ssh用到了expect脚本