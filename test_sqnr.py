from dithered import *
from gennorm import *
'''
reference: Trellis source codes based on linear congruential recursions
Table I, results for gaussian source with variance 4/3
'''
lc_coeff = getLCCoeff()
optScale(4, 1/2, lc_coeff, 0, 1, "gennorm")
x = np.random.normal(0, 1, 1000)
x_hat = gennorm_tcq_rate1(x)
y_hat = gennorm_tcq_fractional_rate(x)