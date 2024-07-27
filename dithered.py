from utils import *
import random

def dithered_tcq_top50(s):
    sparse = top_k_sparsificate_model_weights_tf(s, 0.5)
    non_zero_indices = np.nonzero(sparse)[0]
    seq_in = [sparse[i] for i in non_zero_indices]
    s_hat = dithered_tcq(seq_in)
    for i in range(len(s_hat)):
        sparse[non_zero_indices[i]] = s_hat[i]
    return sparse

def dithered_tcq(s):
    """
    test the input array s from matlab can be computed by python
    :param s: input sequence with shape 1 x (length of s), should be python list
              in matlab, check variable m_fH1, may need to convert the shape to 1 x (length of x) ?
    :return: decoded sequence with shape 1 x(length of s)
             may need to convert the shape back to (length of m_fH1) x 1 in matlab
    """
    random.seed(1)
#    maxA = 3.33
    maxA = 0.5 * max(max(s), -min(s))

    d = np.random.uniform(-maxA / 2, maxA / 2, len(s))
    s = [(x - y) for x, y in zip(s, d)]
    seq_enc = modA(s, maxA)
    lc_coeff = getLCCoeff()
    rate = 1/2
    if rate >= 1:
        quant = SR_LC_Int_Quantizer(2, rate, lc_coeff, 0, np.sqrt((maxA ** 2) / 12), c_scale=1,
                                    source="dithered uniform", modulo_a=maxA)
    else:
        quant = SR_LC_Fractional_Quantizer(2, rate, lc_coeff, 0, np.sqrt((maxA ** 2) / 12),
                                           c_scale=1, source="dithered uniform", modulo_a=maxA)

    quant.encode(seq_enc)
    seq_dec = quant.quant_val
    s_add_dither = [(x + y) for x, y in zip(seq_dec, d)]
    seq_dec_mod_A = modA(s_add_dither, maxA)

    #     uncomment this for testing sqnr, may encounter nan since modA(positive value) could be negative
    #     distortion = [(x - xh) ** 2 for x, xh in zip(seq_dec_mod_A, s)]
    #     sqnr = 10 * np.log10(((maxA**2) / 12) / np.mean(modA(distortion, maxA)))
    #     print("RATE:{}, SQNR:{}".format(rate, sqnr))

    return seq_dec_mod_A

