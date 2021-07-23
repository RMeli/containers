# liGAN Docker Container

Docker container for [GNINA](https://github.com/gnina/gnina).

Includes:

* [libmolgrid](https://github.com/gnina/libmolgrid)
* [gnina](https://github.com/gnina/gnina)

## Notes

### Tests

`libmolgrid` and `gnina` tests are not run when building the container.

```
docker run --gpus all -it gnina /bin/bash

. /root/miniconda3/etc/profile.d/conda.sh && conda activate myenv

cd /software/libmolgrid/build/ && ctest
cd /sofware/gnina/build/ && ctest
```

### Open Babel

The Python version of Open Babel (including `pybel`) needs `swig` to be installed.
