# GNINA Docker Container

Docker container for [GNINA](https://github.com/gnina/gnina).

Includes:

* [libmolgrid](https://github.com/gnina/libmolgrid)
* [gnina](https://github.com/gnina/gnina)

## Usage

### Build 

```
docker build -t gnina .
```

### Save & Load

The Docker container can be saved

```
docker save -o ./gnina.tar gnina
```

and loaded on a differe host:

```
docker load -i ./gnina.tar
```

### Run

```
docker run --gpus all -ti gnina /bin/bash
```

## Notes

### Singularity

[Singularity](https://sylabs.io/singularity/) images can be easily created from local Docker images as follows:
```
sudo singularity build <IMAGE_NAME>.sif docker-daemon://<TAG>
```

### `.dockerignore`

The `.dockerignore` file allows to ignore possible `*.tar` images in the current directory, which would be included in the Docker context sent to the Docker deamon.

### Tests

`libmolgrid` and `gnina` tests are not run when building the container.

```
docker run --gpus all -it gnina /bin/bash

. /root/miniconda3/etc/profile.d/conda.sh && conda activate myenv

cd /software/libmolgrid/build/ && ctest
cd /sofware/gnina/build/ && ctest
```

### Timenzone

Manual entry of the timezone is required when building the container. The following addition solves the issue:

```
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```

### Open Babel

The Python version of Open Babel (including `pybel`) needs `swig` to be installed.
