from setuptools import setup
from Cython.Build import cythonize
import numpy


setup(
    name='Fast material_function',
    ext_modules=cythonize("material_function.pyx"),
    include_dirs=[numpy.get_include()],
    zip_safe=False,
)
