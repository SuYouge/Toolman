<!-- 源码来自：https://blog.csdn.net/SSBBY/article/details/78950960 -->
<html>
<head>
    <!-- 解决弹窗对话框乱码问题 -->
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
</head>
 
<?php
/**
 * 登陆
 * Created by Cory_XuBoYu.
 * User: Administrator
 * Date: 2017/12/28
 * Time: 15:19
 */
if (isset($_POST["submit"]) && $_POST["submit"] == "登录") {
    $id = $_POST["username"];
    $psw = $_POST["password"];
    if ($id == "" || $psw == ""){
        //弹出对话框后返回到先前页面
        echo "<script>alert('请输入用户名或密码！'); history.go(-1);</script>";
    }else {
        //连接数据库
        $servername = "127.0.0.1";
        $username = "root";
        $password = "oz19950715";
        $dbname = "test";
        // 创建连接
        $conn = new mysqli($servername, $username, $password,$dbname);
        // 检测连接
        if ($conn->connect_error) {
            die("连接失败: " . $conn->connect_error);
        }
        //设定字符集,解决数据库插入可能出现乱码，设置编码为GBK
        //构造sql查询语句，需要指定table
        $sql = "select username,password from user where username = '$id' and password = '$psw'";
        //执行SQL语句
        $result = $conn->query($sql);
        //统计执行结果影响的行数
        $num = $result->num_rows;
        //如果已经存在该用户
        if ($num){
            //将数据以索引的方式存储在数组中
            $row = mysqli_fetch_array($result);
            echo $row[0];
            // echo "<script>alert('登陆成功！');history.go(-1);</script>";
            header("refresh:0;url=welcome.html"); // 跳转
        }else{
            //弹出对话框后返回到先前页面
            echo "<script>alert('用户名或者密码不正确！');history.go(-1);</script>";
        }
    }
}else{
    //表单填写不完整弹出对话框后返回到先前页面
    echo "<script>alert('提交未成功！');history.go(-1);</script>";
}
    mysqli_close($conn);
?>