# Windows + Nginx + MySQL + .NET 一键部署方案

## 背景故事
在一次客户现场部署中，使用传统 IIS 部署 .NET 开发的 Web 应用及服务，由于客户笔记本配置老旧并且网络也不好，导致安装和配置 IIS 组件耗时超过 4 小时，客户对部署效率非常不满意。为了解决这个问题，我采用了一套全新的部署方案：Nginx（Windows 版本）、MySQL（免安装版）和 .NET 运行时，并结合 NSSM 管理服务，最终实现了 20 秒内完成部署的速度。

为了方便后续使用，我整理了这套方案，去除了特定于业务的部分（如 MQTT 和 Modbus 客户端、EMQX 免安装版等），形成了通用的 Windows 一键部署脚本，并发布到 Git 上。

---

## 目录结构说明

```
D:/env_soft/
│
├── tools/
│   ├── dotnet8/           # .NET 8 SDK 安装目录
│   ├── mysql8/            # MySQL 安装目录
│   ├── nginx1.28/         # Nginx 安装目录
│   ├── setup/             # 安装脚本
│   └── setup/logs/        # 安装日志
│
└── web/                   # Web 服务相关文件
    └── API.dll            # .NET Web API 主程序文件
```

---

## 软件下载地址

- **MySQL**  
  [https://cdn.mysql.com/archives/mysql-8.0/mysql-8.0.41-winx64.zip](https://cdn.mysql.com/archives/mysql-8.0/mysql-8.0.41-winx64.zip)

- **Nginx**  
  [https://nginx.org/download/nginx-1.28.0.zip](https://nginx.org/download/nginx-1.28.0.zip)

- **.NET 运行时**  
  [https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.408/dotnet-sdk-8.0.408-win-x64.zip](https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.408/dotnet-sdk-8.0.408-win-x64.zip)

---

## 安装脚本说明

所有脚本位于 `tools/setup/` 目录下：

| 脚本名称           | 功能描述 |
|--------------------|----------|
| `一键安装.bat`     | 使用管理员权限执行，可一键安装所有服务 |
| `一键卸载.bat`     | 使用管理员权限执行，可一键卸载所有服务（不删除数据） |
| `install.bat`      | 查询服务安装状态，支持选择性安装或卸载单个/全部服务 |
| `install_***.bat`  | 单独安装或卸载某个服务 |
| `logs/`            | 存放服务安装和控制台输出日志 |

> ⚠️ 注意：卸载后如果需要彻底清除数据，可在卸载完成后删除整个 `env_soft` 文件夹（部分文件可能需要重启后才能删除）。

---

## 配置说明

### 1. MySQL 配置

- **路径依赖**：MySQL 的配置文件 `my.ini` 中使用了绝对路径。如果软件包放在 `D:/env_soft` 目录下，直接运行脚本即可；否则请将 `mysql8/my.ini` 中的所有 `D:/env_soft` 替换为实际路径。
- **默认端口**：6603（如需修改，请编辑 `mysql8/my.ini`）

> 如果你不使用默认数据库，请手动执行数据库脚本并修改连接字符串：
> - 修改位置：`web/appsettings.json`

---

### 2. Web 服务配置

- **启动文件**：必须命名为 `API.dll`
- **默认端口**：5000
- **访问地址**：[http://localhost:5000/](http://localhost:5000/)

---

### 3. Nginx 配置

- **配置文件路径**：`tools\nginx1.28\conf`
- **代理设置**：默认代理本地 5000 端口
- **默认监听端口**：28088
- **访问地址**：[http://localhost:28088/](http://localhost:28088/)

---

## 总结

通过这套一键部署方案，你可以在 **20 秒内完成整个环境的搭建与服务启动**，极大提升了部署效率。适用于快速交付、演示环境搭建、测试环境准备等多种场景。

欢迎将此项目克隆至你的 Git 仓库，并根据自己的业务需求进行扩展！