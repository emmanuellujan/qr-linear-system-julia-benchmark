import scipy.linalg as linalg 
import numpy as np
import time
import matplotlib.pyplot as plt

# np.show_config(): we can check which library numpy is using, e.g. OpenBlas

def solve_qr(A, B):
#    Q, R = linalg.qr(A)
#    y = np.dot(Q.T, B)
#    print(np.shape(R))
#    print(np.shape(y))
#    X = linalg.solve(R, y)
#    return X
    return linalg.lstsq(A,B)[0] # https://numpy.org/doc/stable/reference/generated/numpy.linalg.lstsq.html

def benchmark(f):
    rows = range(1000, 5001, 1000)
    cols = range(30, 101, 10)
    num_sizes = len(rows) * len(cols)
    nexp = 100
    sizes = np.zeros(num_sizes)
    times = np.zeros(num_sizes)
    i = 0
    for r in rows:
        for c in cols:
            s = 0.0
            for e in range(nexp):
                A = np.random.rand(r, c)
                B = np.random.rand(r, 1)
                start = time.time()
                f(A, B)
                end = time.time()
                s += end - start
            end
            sizes[i] = r * c
            times[i] = s / nexp
            i += 1
        end
    end
    return sizes, times


sizes, times = benchmark(solve_qr)
np.savetxt('python-ls.csv', np.column_stack((sizes, times)), fmt='%d, %1.5f', delimiter=',')

