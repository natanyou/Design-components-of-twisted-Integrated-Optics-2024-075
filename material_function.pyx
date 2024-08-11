# cython: language_level=3

import numpy as np
from libc.math cimport sin, cos, tan, pi, sqrt, atan2
cimport numpy as np


cpdef double eps_func(double eps1, double eps0,
                      double width, double height, double length,
                      double alpha, double x, double y, double z):
    cdef double cosaz, sinaz, u, v
    if z > length:
        z = length
    elif z < 0.:
        z = 0.
    cosaz = cos(alpha * z)
    sinaz = sin(alpha * z)
    u = x * cosaz + y * sinaz
    v = y * cosaz - x * sinaz
    if -width <= 2 * u <= width \
        and -height <= 2 * v <= height:
            return eps1
    return eps0

cpdef double moebius_eps_func(double eps1, double eps0,
                      double width, double height, double radius,
                      double twist_angle, double x, double y, double z):
    cdef double r, phi, theta, costheta, sintheta, u, v
    r = sqrt(x * x + y * y) - radius
    phi = atan2(y, x)
    theta = twist_angle * phi / (2 * pi)
    costheta = cos(theta)
    sintheta = sin(theta)
    u = r * costheta + z * sintheta
    v = -r * sintheta + z * costheta
    if -width <= 2 * u <= width \
        and -height <= 2 * v <= height:
            return eps1
    return eps0


cpdef double strip_eps_func(double eps1, double eps0,
                            double width, double height,
                            double xc, double yc,
                            double x, double y):
    # cdef double f0 = eps1 / eps0
    cdef double u = x - xc + width / 2
    cdef double v = y - yc + height / 2
    if x >= xc - width / 2 and x <= xc + width / 2 \
        and y >= yc - height / 2 and y <= yc + height / 2:
            return (eps0 + (eps1 - eps0) * sin(u * pi / width) * sin(v * pi / height))
    return 0.


cpdef double eagle_eps_func(double eps1, double eps0,
                            double width, double height, double length,
                            double alpha, double x, double y, double z):
    cdef double angle, cosaz, sinaz
    if z > length:
        z = length
    elif z < 0.:
        z = 0.
    angle = alpha * z
    cosaz = cos(angle)
    sinaz = sin(angle)
    
    cdef double step = 1.5
    cdef double w_base = 0.5
    cdef double w_at_z, h_at_z
    w_at_z = max(width * cosaz, height * sinaz)
    h_at_z = max(height * cosaz, width * sinaz)
    cdef int ncores = int((w_at_z - 2 * w_base) // step)
    cdef double xmin = 0.
    cdef double xmax = ncores * step
    cdef double[:] centers_x = np.arange(xmin, xmax, step)
    cdef double[:] centers_y = np.empty_like(centers_x)
    cdef double xcenter = (centers_x[-1] + centers_x[0]) / 2
    cdef Py_ssize_t i, n = centers_x.shape[0]
    for i in range(n):
        centers_x[i] -= xcenter
    for i in range(n):
        centers_y[i] = centers_x[i] * tan(pi / 4 - abs(angle - pi / 4))
    cdef double eps_strip, eps = eps0
    cdef double xc, yc
    for i in range(n):
        xc = centers_x[i]
        yc = centers_y[i]
        eps_strip = strip_eps_func(eps1, eps0, w_base, h_at_z, xc, yc, x, y)
        eps += eps_strip
        if eps_strip != 0.:
            break
    return eps

