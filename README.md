# wnmd
windows+nginx+mysql+dotnet的一键部署脚本

# 缘由
某次给客户笔记本上部署软件，使用dotnet开发的web以及服务等，由于使用iis，安装iis的组件更新用了一个多小时，又各种配置用了接近4小时的时间才算部署完成。
客户对这个速度太不满意，问能不能10分钟内搞完？
于是我下载的nginx的windows版本，mysql8的免安装版，dotnet的运行时，使用nssm管理服务，然后写了一系列脚本，最终达到20秒安装完成的结果。

原脚本还包含mqtt和modbus的客户端，emqx的免安装版，出于通用的考虑，把这些移除掉，整理出windows+nginx+mysql+dotnet的一键部署脚本，发布到git上。


# 相关说明
一、文件目录结构
D:/env_soft/
│
├── tools/
│   ├── dotnet8/           # .NET 8 SDK 安
│   ├── mysql8/            # MySQL 安装目录
│   ├── nginx1.28/         # Nginx 安装目录装目录
│   ├── setup/             # 安装脚本
│   └── setup/logs/        # 安装日志
│
└── web/                   # Web 服务相关文件
    └── API.dll            # .NET Web API 主程序文件

mysql下载地址：
https://cdn.mysql.com/archives/mysql-8.0/mysql-8.0.41-winx64.zip
nginx下载地址：
https://nginx.org/download/nginx-1.28.0.zip
dontnet运行时下载地址：
https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.408/dotnet-sdk-8.0.408-win-x64.zip

二、安装脚本说明
安装脚本位于/tools/setup/目录下：
一键安装.bat 使用管理员权限执行此脚本可一键安装所有服务。
一键卸载.bat 使用管理员权限执行此脚本可一键卸载所有服务，但不会删除已有数据，如需删除则在卸载服务后删除整个env_soft文件夹即可（部分文件需要重启后才能删除）。
install.bat 可以查询服务安装状态，选择型安装或卸载单个以及全部的服务
install_***.bat 单独安装或卸载单个服务
logs/ 服务安装和控制台输出日志

三、其它说明
1，mysql配置
mysql配置需要绝对路径，如果软件包放在 D:/env_soft 位置，则直接执行脚本就行，否则修改：
mysql8/my.ini 
批量把 D:/env_soft 替换成正确的目录就可。

mysql默认端口用 6603 ，如需修改找 mysql8/my.ini
默认账号为 root/Buzhizhe@2025

2，如果不使用默认数据库，则需单独执行数据库脚本并更改数据库连接
web/appsettings.json

3，web
web启动文件需为API.DLL
默认启动的端口为5000，配置正常则可访问：http://localhost:5000/

5，nginx
配置文件为 tools\nginx1.28\conf ，代理本地的5000端口
默认配置28088，配置正常则可访问：http://localhost:28088/

