FROM    ubuntu

RUN     echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN     apt-get update
RUN     apt-get install -y \
            curl \
            wget \
            python \
            python-numpy \
            python-scipy \
            python-pip \
            ipython

RUN     wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1204/x86_64/cuda-repo-ubuntu1204_5.5-0_amd64.deb
RUN     dpkg -i cuda-repo-ubuntu1204_5.5-0_amd64.deb
RUN     apt-get update
RUN     grep -v rootfs /proc/mounts > /etc/mtab
RUN     printf "29\n1\n" | apt-get install -y keyboard-configuration
RUN     yes yes | apt-get install -y grub-pc
RUN     DEBCONF_FRONTEND=noninteractive apt-get install -y cuda

ENV     PATH=$PATH:/usr/local/cuda/bin
ENV     LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
ENV     LIBRARY_PATH=LIBRARY_PATH:/usr/local/cuda/lib64

RUN     pip install \
            pycuda \
            Mako \
            scikits.cuda

#       You'll need to download this from
#       http://www.culatools.com/downloads/ (requires sign up)
ADD     cula_dense_free_RC16a-linux.run
RUN     source cula_dense_free_RC16a-linux.run

ADD     cuda.conf /etc/ld.so.conf.d/cuda.conf
ADD     cula.conf /etc/ld.so.conf.d/cula.conf
RUN     ldconfig

