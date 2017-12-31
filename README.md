# Docker Image for [fast.ai](http://course.fast.ai)
My Jupyter environment for fast.ai's Deep Learning MOOC at http://course.fast.ai.

The image starts a  Jupyter notebook on port 8888 with no password.

Uses CPUs by default and NVIDIA GPUs when run with [nvidia-docker](https://github.com/NVIDIA/nvidia-docker).

The container comes with:
- python 3
- miniconda
- Keras
- Tensorflow 1.4
- fastai

To see the full list of packages, look at [environment.yaml](environment.yaml).


## Usage

#### CPU Only
```bash
docker run -it -p 8888:8888 npatta01/deeplearning
```

#### With GPU
```bash
nvidia-docker run -it -p 8888:8888 npatta01/deeplearning
```

## Data management
By default, data in docker containers is ephemeral, so it dissappears if the container is stopped.

To save data, a volume needs to be mounted.

```bash
docker run -it -p 8888:8888 -v ~/custom_data:/home/ubuntu/data npatta01/deeplearning
```

Your local directory "~/custom_data" will be visible in the container and will have data persisted.


## Running on google cloud

Install gcloud sdk
```
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init

gcloud auth login

```

Create a gpu instance
```
bash gcp/start.sh
``` 

Connect to machine
```
gcloud compute ssh dl --ssh-flag="-L 8888:localhost:8888"
```

Install dependencies on VM
```
bash gcp/setup.sh
```

Start Docker container
```
nvidia-docker run -it -p 8888:8888 v ~/custom_data:/home/ubuntu/data npatta01/deeplearning
```
