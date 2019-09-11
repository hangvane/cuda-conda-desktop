
# CUDA-Conda-Desktop

Desktop version of nvidia:cuda docker container, make it easier to build a multi-person shared GPU server.

nvidia:cuda这一docker容器的桌面版本，使用它可以更轻松地搭建多人共享的GPU服务器。

# Introduction

CUDA is a parallel computing platform and programming model developed by NVIDIA for general computing on graphical processing units (GPUs). With CUDA, developers can dramatically speed up computing applications by harnessing the power of GPUs.

This image is the desktop version of nvidia:cuda docker container, make it easier to build a multi-person shared GPU server.

# Tags

[latest(based on nvidia/cuda:10.1-cudnn7-runtime-ubuntu16.04)](https://github.com/hangvane/cuda-conda-desktop/blob/master/Dockerfile)

# How To Use

## Use `docker`

Map the default SSH port 22 to the host's port 6000:

```bash
docker run -dit -p6000:22 hangvane/cuda-conda-desktop:tagname
```

Specify SSH port as 777:

```bash
docker run -dit -p6000:777 -e SSH_PORT=777 hangvane/cuda-conda-desktop:tagname
```

Specify the container's visible GPU as the second block:

```bash
docker run -dit -e NVIDIA_VISIBLE_DEVICES=1 hangvane/cuda-conda-desktop:tagname
```

## Use `nvidia-docker`

Map the default SSH port 22 to the host's port 6000:

```bash
nvidia-docker run -dit -p6000:22 hangvane/cuda-conda-desktop:tagname
```

Specify SSH port as 777:

```bash
nvidia-docker run -dit -p6000:777 -e SSH_PORT=777 hangvane/cuda-conda-desktop:tagname
```

Specify the container's visible GPU as the second block:

```bash
NV_GPU=1 nvidia-docker run -dit hangvane/cuda-conda-desktop:tagname
```

---

Remote SSH access with default username `root` and default password `123456`. Please change your password as soon as possible after logging in.

```bash
passwd
```

Activate conda environment：

```bash
conda activate py37
```

# Improvements

- Added ssh daemon start command and enabled the root login via SSH.
- Installed the commonly used packages: apt-utils, vim, openssh-server, net-tools, iputils-ping, wget, curl, git, iptables, bzip2, command-not-found.
- Switched the encoding to UTF-8, fixed the garbled non-ascii characters in container.
- Installed the latest Miniconda with a conda virtual environment named `py37`.
- Switched the apt source, conda source and pip source of conda env `py37` to TUNA.
- Deleted the NVIDIA apt source, which will not affect the use:<br />
`/etc/apt/sources.list.d/cuda.list`<br />
`/etc/apt/sources.list.d/nvidia-ml.list`
- Added welcome tips for SSH login.

# Build

```bash
git clone https://github.com/hangvane/cuda-conda-desktop.git
cd cuda-conda-desktop
docker image build -t cuda-conda-desktop:tagname .
```

---

# 介绍

CUDA是由NVIDIA开发的用于图形处理单元（GPU）上的通用计算的并行计算平台和编程模型。借助CUDA，开发人员可以利用GPU的强大功能大大加快计算应用程序的速度。

本镜像为CUDA在Ubuntu16.04平台的桌面版本，使之可以更轻松地搭建多人共享GPU服务器。

# 标签

[latest(基于nvidia/cuda:10.1-cudnn7-runtime-ubuntu16.04)](https://github.com/hangvane/cuda-conda-desktop/blob/master/Dockerfile)

# 如何使用

## 使用`docker`

将默认SSH端口22映射到宿主机6000端口：

```bash
docker run -dit -p6000:22 hangvane/cuda-conda-desktop:tagname
```

指定SSH端口为777：

```bash
docker run -dit -p6000:777 -e SSH_PORT=777 hangvane/cuda-conda-desktop:tagname
```

指定容器的可见GPU为第二块：

```bash
docker run -dit -e NVIDIA_VISIBLE_DEVICES=1 hangvane/cuda-conda-desktop:tagname
```

## 使用``nvidia-docker``

将默认SSH端口22映射到宿主机6000端口：

```bash
nvidia-docker run -dit -p6000:22 hangvane/cuda-conda-desktop:tagname
```

指定SSH端口为777：

```bash
nvidia-docker run -dit -p6000:777 -e SSH_PORT=777 hangvane/cuda-conda-desktop:tagname
```

指定容器的可见GPU为第二块：

```bash
NV_GPU=1 nvidia-docker run -dit hangvane/cuda-conda-desktop:tagname
```

---

使用SSH远程登录，默认用户名`root`，密码`123456`，登录后请尽快修改密码：

```bash
passwd
```

激活conda环境：

```bash
conda activate py37
```

# 改进

- 添加了SSH自启动项，允许root远程连接
- 安装了常用的库：apt-utils, vim, openssh-server, net-tools, iputils-ping, wget, curl, git, iptables, bzip2, command-not-found
- 切换编码方式为UTF-8，解决容器内非ASCII字符乱码
- 安装了最新的Miniconda, 附带了一个名为`py37`的conda虚拟环境
- 将apt源, conda源以及py37的pip源切换到TUNA
- 删除了在中国大陆连接缓慢的NVIDIA apt源，不影响使用:
`/etc/apt/sources.list.d/cuda.list` `/etc/apt/sources.list.d/nvidia-ml.list`
- 添加了登录SSH时的欢迎文字

# 自行构建

```bash
git clone https://github.com/hangvane/cuda-conda-desktop.git
cd cuda-conda-desktop
docker image build -t cuda-conda-desktop:tagname .
```

# 参考

- <https://mirrors.tuna.tsinghua.edu.cn/>
- <https://github.com/NVIDIA/nvidia-docker>
