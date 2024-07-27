function m_fHhat = m_fQuantizeData(m_fH)


% Reshape into vector
v_fH = m_fH(:);

% Encoder input divided into blocks
m_fEncInput = reshape(v_fH, 1, []);


% Our proposed TCQ
disp("tcq")
tcq = py.importlib.import_module('dithered');
py.importlib.reload(tcq);
m_fDecOutput = tcq.dithered_tcq(pyargs('s', m_fEncInput));
% convert python list to matlab double
cq = cell(m_fDecOutput);
m_fDecOutput = [cq{:}];


% Re-scale
m_fHhat =  reshape(m_fDecOutput, size(m_fH));