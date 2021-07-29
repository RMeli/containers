# Containers

[Docker](https://www.docker.com/) and [Singularity](https://sylabs.io/singularity/) recipes.

## Singularity

### Build

```bash
sudo singularity build <CONTAINER>.sif <CONTAINER>.def
```

or

```bash
sudo singularity build --notest <CONTAINER>.sif <CONTAINER>.def
```

The `--notest` flag is needed to prevent  [Singularity](https://sylabs.io/singularity/) to run the tests, in case they need GPU support.

### Test

```bash
singularity test --nv <CONTAINER>.sif
```

### Run

#### Interactive

```bash
singularity shell --nv <CONTAINER>.sif
```

#### Application

```bash
singularity run --nv --app <APP> <CONTAINER>.sif [<ARGS>]
```

## Docker

### Build 

```bash
docker build -t <TAG> .
```

### Save & Load

A [Docker](https://www.docker.com/) container can be saved

```
docker save -o ./<NAME>.tar <TAG>
```

and loaded on a differe host:

```
docker load -i ./<NAME>.tar
```

### Run

#### Interactive

```
docker run --gpus all -ti <TAG> /bin/bash
```

## Notes

### Singularity container from Docker container

[Singularity](https://sylabs.io/singularity/) images can be easily created from local Docker images as follows:
```bash
sudo singularity build <IMAGE>.sif docker-daemon://<TAG>
```

### `.dockerignore`

The `.dockerignore` file allows to ignore possible `*.tar` images (and other files) in the current directory, which would be included in the Docker context sent to the Docker deamon.

### Timenzone

Manual entry of the timezone is required when building containers. The following addition solves the issue:

```
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```

## Acknowledgement

The following people contributed code and/or knowledge not reported in the commit history:
* Sebastien Buchoux (@seb-buch)

Their contributions is akcnowledged also in definition files, where appropriate.
