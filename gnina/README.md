# GNINA Docker Container

Docker container for [GNINA](https://github.com/gnina/gnina).

Includes:

* [Open Babel](https://github.com/openbabel/openbabel)
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
docker save -o ./gnina.tar gnina:latest
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

### Timenzone

Manual entry of the timezone is required when building the container. The following addition solves the issue:

```
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
```

### Python

Python 3 is enforced

```
RUN ln -s /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip
```

### Open Babel

The Python version of Open Babel (including `pybel`) needs `swig` to be installed:

```
RUN apt install -y swig
RUN python -m pip install openbabel
```
