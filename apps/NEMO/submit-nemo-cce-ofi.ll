#!/bin/bash
#SBATCH --job-name=nemo
#SBATCH --time=00:30:00
#SBATCH --account=<budget code>
#SBATCH --partition=standard
#SBATCH --qos=standard

#SBATCH --nodes=2
#SBATCH --ntasks-per-core=1

# Created by: mkslurm_hetjob -S 4 -s 16 -m 2 -C 96 -g 2 -N 128 -t 00:10:00 -a n01 -j nemo_test -v False

module -q load PrgEnv-cray
module -q load cray-hdf5-parallel
module -q load cray-netcdf-hdf5parallel


export OMP_NUM_THREADS=1

cat > myscript_wrapper.sh << EOFB
#!/bin/ksh
#
set -A map ${SLURM_SUBMIT_DIR}/xios_server.exe ${SLURM_SUBMIT_DIR}/nemo
exec_map=( 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )
#
exec \${map[\${exec_map[\$SLURM_PROCID]}]}
##
EOFB
chmod u+x ./myscript_wrapper.sh

srun --mem-bind=local \
--ntasks=100 --ntasks-per-node=50 --cpu-bind=v,mask_cpu:0x1,0x10000,0x100000000,0x400000000,0x1000000000,0x4000000000,0x10000000000,0x40000000000,0x100000000000,0x400000000000,0x1000000000000,0x4000000000000,0x10000000000000,0x40000000000000,0x100000000000000,0x400000000000000,0x1000000000000000,0x4000000000000000,0x10000000000000000,0x40000000000000000,0x100000000000000000,0x400000000000000000,0x1000000000000000000,0x4000000000000000000,0x10000000000000000000,0x40000000000000000000,0x100000000000000000000,0x400000000000000000000,0x1000000000000000000000,0x4000000000000000000000,0x10000000000000000000000,0x40000000000000000000000,0x100000000000000000000000,0x400000000000000000000000,0x1000000000000000000000000,0x4000000000000000000000000,0x10000000000000000000000000,0x40000000000000000000000000,0x100000000000000000000000000,0x400000000000000000000000000,0x1000000000000000000000000000,0x4000000000000000000000000000,0x10000000000000000000000000000,0x40000000000000000000000000000,0x100000000000000000000000000000,0x400000000000000000000000000000,0x1000000000000000000000000000000,0x4000000000000000000000000000000,0x10000000000000000000000000000000,0x40000000000000000000000000000000 ./myscript_wrapper.sh


RESULTS_DIR=${SLURM_SUBMIT_DIR}/results/${SLURM_JOB_ID}
mkdir -p ${RESULTS_DIR}
mv ${SLURM_SUBMIT_DIR}/*.nc ${RESULTS_DIR}/
mv ${SLURM_SUBMIT_DIR}/communication_report.txt ${RESULTS_DIR}/
mv ${SLURM_SUBMIT_DIR}/layout.dat ${RESULTS_DIR}/
mv ${SLURM_SUBMIT_DIR}/myscript_wrapper.sh ${RESULTS_DIR}/
mv ${SLURM_SUBMIT_DIR}/ocean.output ${RESULTS_DIR}/
mv ${SLURM_SUBMIT_DIR}/output.namelist.* ${RESULTS_DIR}/
mv ${SLURM_SUBMIT_DIR}/run.stat ${RESULTS_DIR}/
mv ${SLURM_SUBMIT_DIR}/slurm-${SLURM_JOB_ID}.out ${RESULTS_DIR}/slurm.out
mv ${SLURM_SUBMIT_DIR}/time.step ${RESULTS_DIR}/
