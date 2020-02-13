# 简单的登陆系统设计

[登陆流程设计](https://www.jb51.net/article/64969.htm)

## 登陆状态和安全性

[php会话实现登陆功能](https://www.cnblogs.com/happyforev1/articles/1645916.html)

### 登陆状态

> PHP session 解决了服务器不能知道用户的状态的问题，它通过在服务器上存储用户信息以便随后使用（比如用户名称、购买商品等）。然而，会话信息是临时的，在用户离开网站后将被删除。

**启动会话**

```
<?php session_start(); ?>
```
**存储和读取**

```
<?php
session_start();
// 存储 session 数据
$_SESSION['views']=1;
?>
<!--  -->
<?php
// 检索 session 数据
echo "浏览量：". $_SESSION['views'];
?>
```

### 密码存储安全性

[php验证登陆状态和安全性](https://blog.csdn.net/wei349914638/article/details/80893685)

[散列化加密](https://www.php.net/manual/zh/faq.passwords.php)

[MD5加盐加密](https://blog.csdn.net/dream_successor/article/details/82801576)

### 防注入

