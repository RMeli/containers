# GNINA Docker Container

Docker container for [GNINA]().

Includes:

* [Open Babel](https://github.com/openbabel/openbabel)
* [libmolgrid](https://github.com/gnina/libmolgrid)
* [gnina](https://github.com/gnina/gnina)

## Build

```
docker build -t gnina .
```

## Save & Load

The Docker container can be saved

```
docker save -o ./gnina.img gnina:latest
```

and loaded on a differe host:

```
docker load -i ./gnina.img
```

## Run

```
docker run --gpus all -ti gnina /bin/bash
```