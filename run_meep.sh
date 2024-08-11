set -e

NCO=1.5
NCL=1
THETA=180  # deg
L=100  # um
WIDTH=3  # um
HEIGHT=2  # um
WAVELENGTH=1.55  # um
BANDWIDTH=0.01 # um
RESOLUTION=8

N_MPI_CORES=8

python setup.py build_ext --inplace
mpirun -n $N_MPI_CORES python run_meep.py $NCO $NCL $THETA $L $WIDTH $HEIGHT $WAVELENGTH \
    $RESOLUTION --bandwidth $BANDWIDTH
