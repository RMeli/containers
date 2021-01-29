# GNINA Singularity Container

Singularity container for [GNINA](https://github.com/gnina/gnina) development.

Includes:

* [CMake]
* [Open Babel](https://github.com/openbabel/openbabel)

This container *does not* include * [libmolgrid](https://github.com/gnina/libmolgrid) or [gnina](https://github.com/gnina/gnina), but contains all the dependencies needed to install them from source.

## Usage

### Build

```
singularity build obabel.sif obabel.def
```

### Run

```
singularity shell --nv obabel.sif
```