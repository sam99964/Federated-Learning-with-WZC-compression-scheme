from sr_lc_integer_rate_quantizer import *

"""
Inherit from sr_lc_integer_quantizer.py
"""


class SR_LC_Fractional_Quantizer(SR_LC_Int_Quantizer):
    def __init__(self, memory, frac_rate, lc_coeff, mu, s, c_scale=1, source="normal", modulo_a=0,
                 beta=1, distortion_measure='mse'):
        super().__init__(memory, 1, lc_coeff, mu, s, c_scale, source, modulo_a, beta, distortion_measure)
        self.V = int(1 / frac_rate)

    def label_generation(self, k, state):
        vector_valued_label = []
        for v in range(self.V):
            if v == 0:
                g, a = self.lc_coeff[self.rate][self.memory][k]
                vector_valued_label.append((g * state.number + a) % 2 ** self.memory)
            else:
                g, a = self.lc_coeff[self.rate][self.memory][0]
                vector_valued_label.append((g * vector_valued_label[v - 1] + a) % 2 ** self.memory)
        return vector_valued_label

    def distV(self, x, xh):
        assert self.distortion_measure == 'mse', 'Only MSE supported currently'
        if self.distortion_measure == 'mse' and self.source == 'dithered uniform':
            #   distA(g, c) is |(g - c) mod A|^2
            return sum(self.distA(g, c) for g, c in zip(x, xh))
        else:
            return sum((a - b) ** 2 for a, b in zip(x, xh))

    def add_zero_pad(self, x):
        num_of_zeros = len(x) % self.V
        return np.append(x, np.zeros(num_of_zeros)), num_of_zeros

    # Override
    def encode(self, x):
        assert len(x) > 0, 'Input sequence is empty'
        self.input = x
        #   add zeros to x, self.input remain the same
        x, num_of_zeros = self.add_zero_pad(x)
        n = len(x)
        #         forward pass through the trellis to calculate all branch metrics and
        #         save the branches corresponding to the best path(lowest overall distortion)
        for i in range(0, n, self.V):
            for state in self.states:
                for k in range(len(state.next)):
                    #                   create vector-valued label
                    label = self.label_generation(k, state)
                    #                   labels are one-to-one inorder map to reproducer value
                    rxn = [self.y[l] for l in label]
                    next_state = self.num_to_state[state.next[k]]
                    #                    branch metric, assert len(rxn) == self.V
                    bm = self.distV(x[i:i + self.V], rxn)
                    next_state.branches.append((state.number, k, rxn, bm))
            #            find best branch for each state at every timestep
            for state in self.states:
                min_state = None
                min_val = np.inf
                best_rxn = np.inf
                branch_num = None
                for i in range(len(state.branches)):
                    num, k, rxn, bm = state.branches[i]
                    pm = self.num_to_state[num].path_metric
                    if pm + bm < min_val:
                        min_state = num
                        min_val = pm + bm
                        best_rxn = rxn
                        branch_num = k
                state.next_path_metric = min_val
                state.hist.append((min_state, branch_num, best_rxn))

            for state in self.states:
                state.path_metric = state.next_path_metric
                state.branches = []

        #         traceback through the trellis along the best path (lowest overall distortion)
        pms = [state.path_metric for state in self.states]
        state = self.states[np.argmin(pms)]
        self.quant_repr = []
        self.quant_val = []

        #        follow the best branches and store quantized representation and
        #        reconstructed representation
        for i in range(int(n / self.V)):
            num, br, rxn = state.hist[-1 - i]
            self.quant_repr.insert(0, br)
            self.quant_val.insert(0, rxn)
            state = self.num_to_state[num]

        # quant_val = [[0, 1, .., V-1], [0, 1, .., V-1], ...]
        self.quant_val = np.reshape(self.quant_val, len(x)).tolist()
        # remove zeros
        self.quant_val = self.quant_val[:-num_of_zeros] if num_of_zeros > 0 else self.quant_val
        assert len(self.quant_val) == len(self.input), "decode sequence len not equal to input sequence len"
        # calculate overall distortion as absolute value and SQNR
        self.distortion = [self.dist(self.input[i], self.quant_val[i]) for i in range(len(self.input))]
        self.distortion = np.mean(self.distortion)
        self.sqnr = 10 * np.log10((self.s ** 2) / (self.distortion))
        return self.quant_repr
