set -e
conda create -n pmp -c conda-forge pymeep=*=mpi_mpich_*
conda activate pmp
pip install -r requirements.txt
