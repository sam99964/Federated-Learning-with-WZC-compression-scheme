from utils import *


def gennorm_tcq_sparse50(s):
    sparse = top_k_sparsificate_model_weights_tf(s, 0.5)
    non_zero_indices = np.nonzero(sparse)[0]
    s = [sparse[i] for i in non_zero_indices]
    s_hat = gennorm_interface(s, 1)
    for i in range(len(s_hat)):
        sparse[non_zero_indices[i]] = s_hat[i]
    return sparse


def gennorm_tcq_rate1(s):
    return gennorm_interface(s, 1)


def gennorm_tcq_fractional_rate(s):
    return gennorm_interface(s, 1 / 2)


def gennorm_interface(s, rate):
    return gennorm_tcq(s, rate)


def gennorm_tcq(s, rate):
    beta, mu_gennorm, s_gennorm = stats.gennorm.fit(s)
    lc_coeff = getLCCoeff()
    if rate >= 1:
        quant = SR_LC_Int_Quantizer(4, int(rate), lc_coeff, mu_gennorm, s_gennorm, source="gennorm", beta=beta)
    else:
        quant = SR_LC_Fractional_Quantizer(4, rate, lc_coeff, mu_gennorm, s_gennorm, source="gennorm", beta=beta)

    quant.encode(s)
    return quant.quant_val
