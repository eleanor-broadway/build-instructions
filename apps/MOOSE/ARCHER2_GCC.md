# Building MOOSE on ARCHER2

Uses the GCC compilers. Based on instructions at:

 - https://mooseframework.inl.gov/getting_started/installation/hpc_install_moose.html

## Setup environment

```
module load PrgEnv-gnu
module load cray-python
module load cmake

export CC=cc CXX=CC FC=ftn

PRFX=/path/to/build/location
cd $PRFX
```

## Obtain the source code

```
git clone https://github.com/idaholab/moose.git
cd moose
git checkout 2025-09-05-release
```

The instructions below have been tested with the release indicated,
but please feel free to choose a later release if one is available.


## Modify the configuration options for libmesh

ARCHER2 does not have the `libtirpc` headers installed so we need to disable the 
optional XDR functionality (preferred XDA functionality will still be available).

Edit the `scripts/configure_libmesh.sh` file and **remove** the following line
(line 74 of the script in the version we tested):

```
               --enable-xdr-required \
```

If you wish to enable VTK, add the following to the configure command in `scripts/configure_libmesh.sh`: 
```
               --enable-vtk \
```

## Build the dependencies

### Build VTK 

If you wish to enable VTK, build the library and add the location of the install to your environment: 

```
cd $PRFX
mkdir vtk && cd vtk

wget https://vtk.org/files/release/9.6/VTK-9.6.0.tar.gz
tar -xvf VTK-9.6.0.tar.gz
mv VTK-9.6.0 source

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PRFX/vtk/install -DVTK_USE_MPI:BOOL=ON -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=OpenMP -DCMAKE_BUILD_TYPE:STRING=Release ../source 
cmake --build . -j8
cmake --install .

export VTKLIB_DIR=$PRFX/vtk/install/lib64 
export VTKINCLUDE_DIR=$PRFX/vtk/install/include/vtk-9.6
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PRFX/vtk/install/lib64 
```


### Build petsc, libmesh and wasp

```
cd $PRFX/moose/scripts

export MOOSE_JOBS=6 METHODS=opt

./update_and_rebuild_petsc.sh CC=cc CXX=CC FC=ftn
./update_and_rebuild_libmesh.sh CC=cc CXX=CC FC=ftn --with-vtk-lib=$VTKLIB_DIR --with-vtk-include=$VTKINCLUDE_DIR
./update_and_rebuild_wasp.sh
```

## Build MOOSE

### Fix incorrect "build.mk" file

A Fortran flag needs to be added to the compiler configuration. This can be done by editting line 316 in the file `$PRFX/moose/framework/build.mk` to change it to:
```
PLUGIN_FLAGS := -shared -fPIC -Wl,-undefined,dynamic_lookup -fallow-argument-mismatch
```

(i.e. add the "-fallow-argument-mismatch" flag)

### Now build MOOSE

```
cd $PRFX/moose/test
make -j 6
```



## Test MOOSE

From the `moose/test` source directory after building the software.

Create a job submission script with the following contents (change the budget to
one that you have access to on ARCHER2). Once the file is created, submit with
`sbatch` .

```
#!/bin/bash --login

#SBATCH --job-name=moosetest
#SBATCH --nodes=1
#SBATCH --tasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --time=1:0:0
#SBATCH --account=[replace with valid account]
#SBATCH --partition=standard
#SBATCH --qos=standard

# Setup the batch environment
module load PrgEnv-gnu
module load cmake
module load cray-python

# Setup the correct path for MOOSE required libraries
export LD_LIBRARY_PATH=/path/to/moose/petsc/arch-moose/lib:${LD_LIBRARY_PATH}

export OMP_NUM_THREADS=1

export SRUN_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK}

export MOOSE_MPI_COMMAND="srun --unbuffered --hint=nomultithread --distribution=block:block"

./run_tests -j8 -t
```


