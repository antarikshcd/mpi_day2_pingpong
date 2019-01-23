#!/bin/sh
#PBS -r n
#PBS -N ping_pong_1
##PBS -l nodes=1:ppn=2
#PBS -l nodes=2:ppn=1
#PBS -j oe
#PBS -o ping_pong_out.out
#PBS -l walltime=00:10:00

NPROCS=`wc -l < $PBS_NODEFILE` 
echo "NPROCS = " $NPROCS

module add studio
module add mpi/studio
# export PATH=$PATH:/opt/openmpi/1.6.5/sun/bin/mpirun
# change the cd ... below to reach your executable

cd $PBS_O_WORKDIR 

# count=2^0
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 1
# count=2^1
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 2
# count=2^2
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 4
# count=2^3
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 8
# count=2^4
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 16
# count=2^5
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 32
# count=2^6
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 64
# count=2^7
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 128
# count=2^8
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 256
# count=2^9
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 512
# count=2^10
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 1024
# count=2^11
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 2048
# count=2^12
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 4096
# count=2^13
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 8192
# count=2^14
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 16384
# count=2^15
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 32768
# count=2^16
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 65536
# count=2^17
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 131072
# count=2^18
/opt/openmpi/1.6.5/sun/bin/mpirun -np $NPROCS ./ping_pong.exe 262144
