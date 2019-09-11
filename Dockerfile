FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu16.04
LABEL version="1.0"
LABEL description="Desktop version of nvidia:cuda docker container, make it easier to build a multi-person Shared GPU server."
LABEL MAINTAINER hangvane<hangvane1@gmail.com>
ENV SSH_PORT 22
#
# UTF-8 encoding to support chs characters
#
RUN echo "export LANG=C.UTF-8" >>/etc/profile \
#
# apt sources backup
#
&& cp /etc/apt/sources.list /etc/apt/sources.list.bak \
#
# switch apt source to TUNA
#
&& echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >/etc/apt/sources.list \
#
# remove nvidia sources
#
&& rm /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list \
#
# install the necessary packages
#
&& apt-get update \
&& apt-get install -y --no-install-recommends \
  apt-utils \
  vim \
  openssh-server \
  net-tools \
  iputils-ping \
  wget \
  curl \
  git \
  iptables \
  bzip2 \
  command-not-found \
#
# download & install miniconda
#
&& wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&& bash Miniconda3-latest-Linux-x86_64.sh -b \
&& rm Miniconda3-latest-Linux-x86_64.sh \
&& ln -s /root/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
#
# switch conda source to TUNA
#
&& echo "channels:\n\
  - defaults\n\
show_channel_urls: true\n\
default_channels:\n\
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main\n\
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r\n\
custom_channels:\n\
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n\
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n\
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n\
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n\
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >/root/.condarc \
#
# create conda py37 environment
#
&& /root/miniconda3/bin/conda create -npy37 python=3.7 -y \
#
# switch pip source to TUNA & update pip
#
&& /root/miniconda3/envs/py37/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
&& /root/miniconda3/envs/py37/bin/pip install pip -U \
#
# enable root access with ssh
#
&& sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
#
# set root password
#
&& echo "root:123456" | chpasswd \
#
# change ssh port & start ssh service when docker container starts
#
&& echo "#!/bin/bash\n\
sed -i \"s/Port 22/Port \$SSH_PORT/g\" /etc/ssh/sshd_config\n\
service ssh start\n\
/bin/bash" >/home/startup.sh \
&& chmod 777 /home/startup.sh \
#
# add welcome tips
#
&& echo "\
printf '\\\n'\n\
printf '\\\033[0;34m'\n\
printf ' Welcome to GPU server\\\n'\n\
printf ' Please change the default root password in time\\\n'\n\
printf '\\\n'\n\
printf ' CUDA:\\\t\\\tv10.1.105\\\n'\n\
printf ' CUDNN:\\\t\\\tv7.5.0.56\\\n'\n\
printf ' Conda:\\\t\\\tMiniconda v4.7.10  use `conda activate py37` to activate conda env\\\n'\n\
printf ' SSH port:\\\t$SSH_PORT for this container\\\n'\n\
printf '\\\033[0m'\n\
printf '\\\n'\n\
" >>/etc/update-motd.d/10-help-text \
#
# cleanup
#
&& rm -rf /var/lib/apt/lists/* /tmp/*
#
# set startup script
#
ENTRYPOINT /home/startup.sh