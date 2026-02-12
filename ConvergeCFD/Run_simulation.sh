#!/bin/bash

#SBATCH --partition=win_all
#SBATCH --job-name=CASE4
#SBATCH --ntasks 40

#SBATCH --output=my_converge_output.txt

mpiexec -n $SLURM_NPROCS converge-mpich super
