
res_f = zeros(1,800);
res_score_f = zeros(8,800);

% mask = ones(1,11);
mask = ones(1,21);

% mask = [1 2 3 4 5 6 5 4 3 2 1];
% mask = [1 2 3 4 5 6 7 8 9 10 11 10 9 8 7 6 5 4 3 2 1];

% mask = gausswin(11)';
% mask = gausswin(21)';

mask = mask./sum(mask);

for emo_f = 1:8
    port = res_score(emo_f,:);
    port_f = conv(port, mask, 'same');
    res_score_f(emo_f,:) = port_f;
end

for i_b = 1:800
    [v, res_f(i_b)] = max(res_score_f(:,i_b));
    res_score_f(:,i_b) = res_score_f(:,i_b)./sum(res_score_f(:,i_b));
end

