set -e

NCO=1.5
NCL=1
THETA=180  # deg
RADIUS=20  # um
WIDTH=3  # um
HEIGHT=2  # um
WAVELENGTH=1.55  # um
BANDWIDTH=0.01 # um
RESOLUTION=16

N_MPI_CORES=31

# python setup.py build_ext --inplace
mpirun -n $N_MPI_CORES python run_meep_moebius.py $NCO $NCL $THETA $RADIUS $WIDTH $HEIGHT $WAVELENGTH \
    $RESOLUTION --bandwidth $BANDWIDTH
