# docker build -t rlhf-teacher .
# docker run \
#   -v ./logs:/app/logs \
#   -v ./data/media:/tmp/rl_teacher_media \
#   -v ./human-feedback-api/db.sqlite3:/app/human-feedback-api/db.sqlite3 \
#   -p 18081:6006 -p 18080:8000 \
#   rlhf-teacher -- -p human --pretrain_labels 150 -e Hopper-v1 -n hopper-flip

FROM python:3.5-slim

ENV DEBIAN_FRONTEND=noninteractive

# install apt dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libmpich-dev \
        libopenmpi-dev \
        zip \
        libgl1 \
        libglu1-mesa \
        libxrandr2 \
        libxrandr-dev \
        libx11-dev \
        libxinerama1 \
        libxi6 \
        libxcursor1 \
        libosmesa6-dev \
        libgl1-mesa-dev \
        patchelf \
        ffmpeg \
        libpq-dev \
        libjpeg-dev \
        cmake \
        swig \
        python-opengl \
        libboost-all-dev \
        libsdl2-dev \
        xorg \
        xserver-xorg-video-dummy \
        x11-xserver-utils \
        xvfb \
        wget \
        unzip \
        net-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir mpi4py==3.0.3 multiprocess==0.70.11.1 && \
    pip install --no-cache-dir tensorflow==1.2 protobuf==3.2

RUN mkdir /root/.mujoco && \
    cd /root/.mujoco && \
    wget https://www.roboti.us/download/mjpro131_linux.zip -O mjpro131_linux.zip && \
    unzip mjpro131_linux.zip && \
    rm mjpro131_linux.zip && \
    wget https://www.roboti.us/file/mjkey.txt -O mjkey.txt

COPY . /app
WORKDIR /app
RUN chown -R root:root .

RUN pip install --no-cache-dir -e . && \
    pip install --no-cache-dir -e human-feedback-api && \
    pip install --no-cache-dir -e agents/parallel-trpo[tf] && \
    pip install --no-cache-dir -e agents/pposgd-mpi[tf] && \
    rm -rf /root/.cache/pip

ENV DISPLAY=:0

RUN python human-feedback-api/manage.py migrate --noinput && \
    python human-feedback-api/manage.py collectstatic --noinput

ENTRYPOINT ["sh", "-c", "Xvfb :0 -screen 0 1024x768x16 & sleep 3 && \
    tensorboard --logdir=./logs --port=6006 & sleep 1 && \
    python human-feedback-api/manage.py runserver 0.0.0.0:8000 & sleep 1 && \
    python rl_teacher/teach.py $@ && \
    echo 'Waiting for background jobs.' && wait"]
