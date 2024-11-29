Instructions for installing SCons 4.8.1 on ARCHER2
==================================================

These instructions show how to install Scons 4.8.1 for use on ARCHER2 (HPE Cray EX, AMD Zen2 7742).


Setup initial environment
-------------------------

```bash
PRFX=/path/to/work  # e.g., PRFX=/mnt/lustre/a2fs-work4/work/y07/shared/python/core
SCONS_LABEL=scons
SCONS_VERSION=4.8.1
SCONS_ROOT=${PRFX}/${SCONS_LABEL}

module load PrgEnv-gnu
module load cray-python

PYTHON_VER=`echo ${CRAY_PYTHON_LEVEL} | cut -d'.' -f1-2`
PYTHON_DIR=${PRFX}/${SCONS_LABEL}/${SCONS_VERSION}/python
PYTHON_BIN=${PYTHON_DIR}/${CRAY_PYTHON_LEVEL}/bin
```

Remember to change the setting for `PRFX` to a path appropriate for your ARCHER2 project.


Create and setup the SCons virtual python environment
-----------------------------------------------------

```bash
mkdir -p ${PYTHON_BIN}

export PIP_CACHE_DIR=${PYTHON_DIR}/.cache/pip

export PYTHONUSERBASE=${PYTHON_DIR}/${CRAY_PYTHON_LEVEL}
export PATH=${PYTHONUSERBASE}/bin:${PATH}
export PYTHONPATH=${PYTHONUSERBASE}/lib/python${PYTHON_VER}/site-packages:${PYTHONPATH}

pip install --user --upgrade pip
```


Install the SCons together with supporting packages
---------------------------------------------------

```bash
pip install --user ninja
pip install --user latex
pip install --user ${SCONS_LABEL}==${SCONS_VERSION}
```
