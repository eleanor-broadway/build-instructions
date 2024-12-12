Instructions for compiling VASP 5.4.4 for ARCHER2 using GCC compilers
====================================================================

These instructions are for compiling VASP 5.4.4 on [ARCHER2](https://www.archer2.ac.uk)
using the GCC compilers and using HPE Cray LibSci for BLAS/LAPACK/ScaLAPACK.

We assume that you have obtained the VASP source code from the VASP website along
with any relevant patches.

Unpack the VASP source code and apply patches
---------------------------------------------

Unpack the source

```bash
tar -xvf vasp.5.4.4.pl2.tar.gz
```

Apply any patches according to the instructions on the VASP website.

Setup correct modules
---------------------

Setup the GCC compiler environment, switch to GCC 10.3.0 and load FFTW:

```bash
module load PrgEnv-gnu
module load gcc/10.3.0
module load cray-fftw
```

Modules loaded at build time:

```
Currently Loaded Modules:
  1) craype-x86-rome                         6) bolt/0.8          11) cray-libsci/22.12.1.1
  2) libfabric/1.12.1.2.2.0.0                7) epcc-setup-env    12) PrgEnv-gnu/8.3.3
  3) craype-network-ofi                      8) load-epcc-module  13) gcc/10.3.0
  4) perftools-base/22.12.0                  9) craype/2.7.19     14) cray-mpich/8.1.23
  5) xpmem/2.5.2-2.4_3.30__gd0f7936.shasta  10) cray-dsmml/0.2.2  15) cray-fftw/3.3.10.3

```

Create makefile.include
-----------------------

The new build process for VASP (introduced for version 5.4.1) requires the
correct options to be set in makefile.include in the root directory of the
source distribution.

The makefile.include used for the GCC compilers on ARCHER2 can be downloaded from:

* [5.4.4_makefile.include.ARCHER2_GCC](5.4.4_makefile.include.ARCHER2_GCC)

The GCC build on ARCHER2 uses:

* HPE Cray LibSci for BLAS/LAPACK/ScaLAPACK
* FFTW 3 for FFT's

You should copy this file to the root directory of the VASP source distribution
and then rename it to "makefile.include":

```bash
mv 5.4.4_makefile.include.ARCHER2_GCC makefile.include
```

Build VASP
----------

You build all the VASP executables with:

```bash
make veryclean
make all
```

This will produce the following executables in the bin directory:

* `vasp_std` - Multiple k-point version
* `vasp_gam` - GAMMA-point version
* `vasp_ncl` - Non-collinear version

All versions include the additional MD algorithms accessed via the MDALGO keyword.


