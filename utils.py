from sr_lc_integer_rate_quantizer import *
from sr_lc_fractional_rate_quantizer import *


def sqnr(memory, rate, lc_coeff, mu, s, c_scale, frame_len=1e3, n_frames=1000):
    """
    calculate and return the SQNR of the quantizer based on n_frames of
    length frame_len
    """
    n = int(frame_len)
    # start-up frame
    x = np.random.normal(mu, s, n)
    quant = SR_LC_Int_Quantizer(memory, rate, lc_coeff, mu, s, c_scale)
    quant.encode(x)
    # testing frames
    sqnr = []
    for i in range(n_frames):
        x = np.random.normal(mu, s, n)
        quant.encode(x)
        sqnr.append(quant.sqnr)

    print("mean SQNR = {:.4} {}".format(np.mean(sqnr), "dB"))
    CI = stats.t.interval(0.95, len(sqnr) - 1, loc=np.mean(sqnr), scale=stats.sem(sqnr))
    print("95% CI size = {:.4} {}".format(CI[1] - CI[0], "dB"))
    quant.reset()

    return np.mean(sqnr)


def optScale(memory, rate, lc_coeff, mu, s, source, c_lb=0.5, c_ub=1.5, n_points=20):
    """
    Optimize the scale factor of the reproducer values using a simple line search
    from c_lb to c_ub split into n_points
    """
    c = np.linspace(c_lb, c_ub, n_points)
    n_frames = 10
    n = 10000
    all_sqnr = []
    for c_val in c:
        x = np.random.normal(mu, s, n)
        if rate >= 1:
            quant = SR_LC_Int_Quantizer(memory, rate, lc_coeff, mu, s, c_scale=c_val, source=source)
        else:
            quant = SR_LC_Fractional_Quantizer(memory, 1/2, lc_coeff, mu, s, c_scale=c_val, source=source)
        quant.encode(x)
        # testing frames
        sqnr = []
        for i in range(n_frames):
            x = np.random.normal(mu, s, n)
            quant.encode(x)
            sqnr.append(quant.sqnr)

        print("c_scale = {:.4}".format(c_val))
        print("mean SQNR = {:.4} {}".format(np.mean(sqnr), "dB"))
        CI = stats.t.interval(0.95, len(sqnr) - 1, loc=np.mean(sqnr), scale=stats.sem(sqnr))
        print("95% CI size = {:.4} {}".format(CI[1] - CI[0], "dB"))
        all_sqnr.append(np.mean(sqnr))
        quant.reset()
    print("Best SQNR = {:.4} {}, c_scale = {}".format(np.max(all_sqnr), "dB", c[np.argmax(all_sqnr)]))
    best_c = c[np.argmax(all_sqnr)]

    return best_c


def getLCCoeff():
    """
    Label generating LC coefficients for various rates and memory sizes
    """

    lc_coeff_r_0 = {2: [(5, 0)],
                    3: [(5, 0)],
                    4: [(5, 0)]}

    lc_coeff_r_1 = {2: [(5, 2), (5, 0)],
                    3: [(5, 7), (5, 3)],
                    4: [(5, 4), (5, 12)]}

    lc_coeff_r_2 = {2: [(5, i) for i in range(4)],
                    3: [(5, 2 * i) for i in range(8)],
                    4: [(5, 4 * i) for i in range(16)]}

    lc_coeff_r_3 = {3: [(5, i) for i in range(8)],
                    4: [(5, 2 * i) for i in range(16)]}

    lc_coeff_r_4 = {4: [(5, i) for i in range(16)],
                    5: [(5, 2 * i) for i in range(32)]}

    lc_coeff_r_5 = {5: [(5, i) for i in range(32)],
                    6: [(5, 2 * i) for i in range(64)]}

    lc_coeff_r_6 = {6: [(5, i) for i in range(64)],
                    7: [(5, 2 * i) for i in range(128)]}

    lc_coeff_r_7 = {7: [(5, i) for i in range(128)],
                    8: [(5, 2 * i) for i in range(256)]}

    lc_coeff = {0: lc_coeff_r_0, 1: lc_coeff_r_1, 2: lc_coeff_r_2, 3: lc_coeff_r_3,
                4: lc_coeff_r_4, 5: lc_coeff_r_5, 6: lc_coeff_r_6,
                7: lc_coeff_r_7}

    return lc_coeff


def modA(x, A):
    xmodA = []
    for ele in x:
        if ele > 0:
            b = ele // A
            if np.abs(ele - A * b) > np.abs(ele - A * (b + 1)):
                b = b + 1
        elif ele < 0:
            b = ele // A + 1  # want floor
            if np.abs(ele - A * b) > np.abs(ele - A * (b - 1)):
                b = b - 1
        else:
            b = 0
        xmodA.append(ele - b * A)
    return xmodA


def top_k_sparsificate_model_weights_tf(weights, fraction):
    # 0 < fraction <= 1
    tmp_list = np.abs(weights).tolist()
    tmp_list.sort(reverse=True)
    k_th_element = tmp_list[int(fraction*len(tmp_list))-1]
    new_weights = []
    for el in weights:
        if abs(el) < k_th_element:
            new_weights.append(0.0)
        else:
            new_weights.append(el)
    return new_weights
