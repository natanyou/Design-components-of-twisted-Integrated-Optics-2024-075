import sys, os, gc
os.environ['OPENBLAS_NUM_THREADS'] = '1'
import meep as mp
import numpy as np
import pickle
import argparse
from mpi4py import MPI
import h5py
import setuptools
import pyximport
# pyximport.install(language_level=3,
#                   reload_support=False)
from material_function import eps_func


output_dir = 'outputs'

parser = argparse.ArgumentParser()
parser.add_argument('nco', type=float)
parser.add_argument('ncl', type=float)
parser.add_argument('angle', type=float)
parser.add_argument('length', type=float)
parser.add_argument('width', type=float)
parser.add_argument('height', type=float)
parser.add_argument('wl', type=float)
parser.add_argument('resolution', type=int, default=1)
parser.add_argument('--nslices', type=int, default=2)
parser.add_argument('--until', type=float, default=None)
parser.add_argument('--bandwidth', type=float, default=None)
args = parser.parse_args()


def twisted_guide(nco, ncl, width, height, angle, length):
    alpha = np.radians(angle) / length

    width = float(width)
    height = float(height)
    angle = float(angle)
    length = float(length)
    eps1 = nco ** 2
    eps0 = ncl ** 2

    def tg_eps_func(point: mp.Vector3):
        def wrapper(point):
            x = point.x
            y = point.y
            z = point.z
            return eps_func(eps1, eps0, width, height, length, alpha, x, y, z)
        return wrapper(point)

    return tg_eps_func


def create_simulation(nco, ncl, angle, length, width, height, wl, bw, resolution):
    tg = twisted_guide(nco, ncl, width, height, angle, length)
    dpml = 1

    global nonpml_vol, cell_size, cell_center, cell_volume, sxy
    sxy = 1.7 * max(width, height)
    cell_center = mp.Vector3(0, 0, length / 2)
    cell_size = mp.Vector3(sxy + 2 * dpml, sxy + 2 * dpml, length + 2 + 2 * dpml)
    cell_volume = mp.Volume(center=cell_center, size=cell_size)
    nonpml_vol = mp.Volume(center=cell_center, size=mp.Vector3(sxy, sxy, length))

    geometry = [mp.Block(center=cell_center,
                         size=mp.Vector3(width, width, length),
                         material=tg)]

    beta = nco / wl
    sources = [mp.EigenModeSource(mp.GaussianSource(wavelength=wl, width=bw, cutoff=2),
                                  center=mp.Vector3(z=-0.5),
                                  size=mp.Vector3(sxy, sxy),
                                  eig_match_freq=True,
                                  eig_kpoint=mp.Vector3(z=beta),
                                  eig_band=1,
                                  eig_resolution=resolution)]

    pml_layers = [mp.PML(thickness=dpml)]
    filename_prefix = "{:.0f}deg-{:.0f}um".format(angle, length)
    sim = mp.Simulation(cell_size,
                        resolution=resolution,
                        epsilon_func=tg,
                        geometry_center=cell_center,
                        sources=sources,
                        force_complex_fields=False,
                        boundary_layers=pml_layers,
                        filename_prefix=filename_prefix,
                        output_volume=nonpml_vol)
    sim.use_output_directory(output_dir)
    sim.filename_prefix = filename_prefix
    return sim


def main(args):
    nco, ncl = args.nco, args.ncl
    angle = args.angle
    length = args.length
    width = args.width
    height = args.height
    wl = args.wl
    freq = 1 / wl
    bandwidth = args.bandwidth
    if bandwidth is None:
        bandwidth = 40 * args.wl
    resolution = args.resolution
    nslices = args.nslices
    until = args.until
    sys.stdout.write('Starting simulation with parameters:\n')
    sys.stdout.write('  nco, ncl = {}, {}\n'.format(nco, ncl))
    sys.stdout.write('  angle = {} deg\n'.format(angle))
    sys.stdout.write('  length = {}\n'.format(length))
    sys.stdout.write('  width x height = {} x {}\n'.format(width, height))
    sys.stdout.write('  wavelength = {:.4g}\n'.format(wl))
    sys.stdout.write('  bandwidth = {:.4g}\n'.format(bandwidth))
    sys.stdout.write('====================================\n')
    sim = create_simulation(nco, ncl, angle, length, width, height, wl, bandwidth, resolution)
    dft_slices = []
    zs = np.linspace(0, length, nslices)
    comps = dict(Ex=mp.Ex, Ey=mp.Ey, Ez=mp.Ez, Hx=mp.Hx, Hy=mp.Hy, Hz=mp.Hz)
    for z in zs:
        dft_slice = sim.add_dft_fields(list(comps.values()), freq, 0, 1,
                                       center=mp.Vector3(z=z), size=mp.Vector3(sxy, sxy))
        dft_slices.append(dft_slice)

    dft_point = sim.add_dft_fields()

    # Create name for the HDF5 file
    #========================================
    filename = os.path.join(output_dir, sim.filename_prefix + '.h5')

    # By default, run simulation until the excited wavepacket
    # passes through the whole waveguide
    #=======================================
    if not until:
        sim.run(until_after_sources=1.5 * nco * length)
    else:
        sim.run(until=until)

    sys.stdout.write('Saving DFT fields\n')
    with h5py.File(filename, 'w', driver='mpio', comm=MPI.COMM_WORLD) as f:
        nx, ny = sim.get_dft_array(dft_slices[0], mp.Ex, 0).shape
        nz = nslices
        for comp, mpcomp in comps.items():
            f.create_dataset(comp,
                             shape=(nx, ny, nz),
                             dtype=np.complex64, chunks=(nx, ny, 1))
            for i in range(nslices):
                arr = sim.get_dft_array(dft_slices[i], mpcomp, 0)
                if mp.am_master():
                    f[comp][:, :, i] = arr
            sys.stdout.write('Saved {}\n'.format(comp))
    sys.stdout.write('\nDFT fields saved to {}\n'.format(filename))
    return sim


if __name__ == '__main__':
    SLURM_JOBID = os.environ.get('SLURM_JOBID')
    if SLURM_JOBID:
        sys.stdout.write("JOBID: {}\n".format(SLURM_JOBID))
    sim = main(args)
