% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function payoff = trans_european_call(ST,trans_params)
% Returns Payoff(s) for European Call with Value(s) ST at Expiry T, given
% Strike Price K and Risk-Free Interest Rate r
    
    r = trans_params(1); % Risk-Free Interest Rate
    T = trans_params(2); % Time to Expiry
    K = trans_params(3); % Strike Price
    
    % Payoff Function
    payoff = exp(-r*T)*max(ST-K,0);
    
end