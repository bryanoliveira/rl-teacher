FROM hccz95/ubuntu:18.04
RUN ./replace-mirrors.sh

# install apt dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential libmpich-dev libopenmpi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN conda create -n py36 python=3.6 && \
    echo "conda activate py36" >> ~/.bashrc && \
    conda clean -a -y
SHELL ["conda", "run", "-n", "py36", "/bin/bash", "-c"]

RUN git clone https://gitee.com/hccz95/rl-teacher.git && \
    cd rl-teacher/ && \
    pip install tensorflow==1.2 protobuf==3.2 && \
    pip install -e . && \
    pip install -e human-feedback-api && \
    pip install -e agents/parallel-trpo[tf] && \
    pip install -e agents/pposgd-mpi[tf] && \
    rm -rf /root/.cache/pip

RUN apt update && apt install -y \
        zip libgl1 libglu1-mesa libxrandr2 libxinerama1 libxi6 libxcursor1 \
        build-essential libosmesa6-dev libgl1-mesa-dev patchelf && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /root/.mujoco && \
    cd /root/.mujoco && \
    wget https://www.roboti.us/download/mjpro131_linux.zip -O mjpro131_linux.zip && \
    unzip mjpro131_linux.zip && \
    rm mjpro131_linux.zip && \
    wget https://www.roboti.us/file/mjkey.txt -O mjkey.txt
