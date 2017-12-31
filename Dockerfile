FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

MAINTAINER Nidhin Pattaniyil <npattaniyil@gmail.com>

ARG CONDA_PYTHON_VERSION=3
ARG CONDA_VERSION=4.3.31
ARG CONDA_DIR=/opt/conda
ARG TINI_VERSION=v0.16.1
ARG USERNAME=ubuntu

# Conda
ENV CONDA_ENV dl

ENV PATH $CONDA_DIR/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget git unzip ffmpeg sudo libxrender-dev libsm6 libxext6 && \
  wget --quiet https://repo.continuum.io/miniconda/Miniconda$CONDA_PYTHON_VERSION-$CONDA_VERSION-Linux-x86_64.sh -O /tmp/miniconda.sh && \
  /bin/bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
  rm -rf /tmp/* && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Tini makes notebook kernels work
ADD https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini /tini
RUN chmod +x /tini

RUN useradd -ms /bin/bash $USERNAME && \
  chown $USERNAME $CONDA_DIR -R && \
  adduser $USERNAME sudo && \
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME


COPY environment.yml .
RUN conda env update -f=environment.yml -n root 
#RUN conda env update -f=environment_additional.yml 

COPY environment_additional.yml . 
RUN conda env update -f environment_additional.yml  -n root

COPY jupyter_notebook_config.py .jupyter/

# Jupyter
EXPOSE 8888


# Clone fast.ai source
RUN git clone -q https://github.com/fastai/courses.git fastai-courses

ENTRYPOINT ["/tini", "--"]
CMD jupyter notebook --port=8888
#CMD /bin/bash

