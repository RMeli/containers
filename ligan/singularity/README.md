# GNINA Singularity Container

Singularity containers for [GNINA](https://github.com/gnina/gnina).

## Usage

### Build

```
sudo singularity build --notest <CONTAINER>.sif <CONTAINER>.def
```

The `--notest` flag is needed to prevent Singularity to run the tests, in case they need GPU support.

### Test

```
singularity test --nv <CONTAINER>.sif
```

### Run

```
singularity shell --nv <CONTAINER>.sif
```

## Notes

### Open Babel

The container `obabel.def` *does not* include [libmolgrid](https://github.com/gnina/libmolgrid) or [gnina](https://github.com/gnina/gnina), but contains all the dependencies needed to install them from source.