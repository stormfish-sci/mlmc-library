% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

% -------------------------------------------------------------------------
% Level Estimator: 
% - Geometric Brownian Motion Stochastic Differential Equation:
% -- dSt = mu*St*dt + sig*St*dW
% - with Euler-Maruyama Discretisation.
%
% -------------------------------------------------------------------------

function [LEs_moments] = level_sde_gbm_euler(l,N,level_params,trans_fname,trans_params)
% MLMC Estimator at level l with geometric level factor M on N samples
% - Returns Estimate for to E[Y(l)]= E[P(l)-P(l-1)] for N Samples using 
%   'Fine' and 'Coarse' Approximations on Level L
% - LEs(1) is the Level Estimator, LEs(2:4) are Higher-Order Moments of
%   E[Y(l)], and LEs(5:6) are the First Two Moments Constructed from the
%   'Fine' Approximations Only.

    M = level_params(1); % Geometric Level Factor
    mu = level_params(2); % Percentage Drift
    sig = level_params(3); % Percentage Volatility
    S0 = level_params(4); % Initial Value
    T = level_params(5); % Time Interval, where t = 0...T 
    
    nf = M^l; % Number of Sub-Intervals between 0 and T on the 'Fine' Level
    hf = T/nf; % Size (Step-Size) on 'Fine' Level
    
    nc = nf/M; % Number of Sub-Intervals between 0 and T on the 'Coarse' Level
    hc = T/nc; % Size (Step-Size) on 'Coarse' Level

    sums = zeros(6,1); % Storage: First Four Moments of E[Y(l)] and First Two of Construction on 'Fine' Level, tf(Sf)
    
    % Construction of N Samples
    % - Vectorizing, but Breaking out into RAM-Manageable Chunks        
    for n_step2N = 1:10000:N
        
        n_chunk = min(10000,N-n_step2N+1); % Creates <= 100K Samples each Loop to get N in Total

        Sf = S0.*ones(n_chunk,1); % Initializing Estimates for Samples on 'Fine' Intervals
        Sc = S0.*ones(n_chunk,1); % Initializing Estimates Estimate for Samples on 'Coarse' Intervals
   
        % For Level '0': Use 'Fine' Interval for Storing Samples at l=0; (with no 'Coarse' Construction)
        if l == 0
            dW = sqrt(T)*randn(n_chunk,1);
            Sf = Sf + mu*Sf*T + sig*Sf.*dW;
        % For Levels > 0: Constructing 'Fine' Levels; Chaining Together to get 'Coarse' Levels
        else        
            for c_int = 1:nc % Looping through Each Sub-Interval on the 'Coarse' Level
                dWc = zeros(n_chunk,1); % Initializing 'Coarse' dW
                for f_int = 1:M % Loops through Amount of 'Fine' Intervals (per 'Coarse' Interval)
                    dWf = sqrt(hf)*randn(n_chunk,1); % Generates a 'Fine' dW
                    Sf = Sf + mu*Sf*hf + sig*Sf.*dWf; % Constructs/Adds onto the 'Fine' Path
                    dWc = dWc + dWf; % Constructs/Adds onto the 'Coarse' dW (*Key Part: Linking up Fine/Coarse Levels)
                end
                Sc = Sc + mu*Sc*hc + sig*Sc.*dWc; % Constructs/Adds onto the 'Coarse' Path
            end
        end
        
       % Transforms SDE Output if Transform Function is Specified; Else
       % Just Takes Differences between 'Fine' and 'Coarse' Paths
       % - E.g., a Transform Function can be a 'Payoff' Function that
       % depends on the Underlying SDE, like a 'Call' or 'Put' Option
       try
           % Converts Function Name to Function handle
           trans_fn = str2func(regexprep(trans_fname,'.m',''));
           % Transform Output of SDE according to Transform Function
           % - trans_params is an Optional Vector of Parameters
           tf_Sf = trans_fn(Sf,trans_params);
           if l == 0
               tf_Sc = zeros(n_chunk,1); % Note: No 'Coarse' Specification for Level 0
           else
               tf_Sc = trans_fn(Sc,trans_params);
           end                   
       catch
           % Uses Current Values if No Transform Function is Specified
           tf_Sf = Sf;
           if l == 0
                tf_Sc = zeros(n_chunk,1);  % Note: No 'Coarse' Specification for Level 0
           else
                tf_Sc = Sc;
           end
       end

       % Constructing E[Y(l)] in MLMC Terminology (Level Differences)
       % - Just the Sum Part Here
       sums(1) = sums(1) + sum(tf_Sf-tf_Sc); % E[Y(l)] = S(l)-S(l-1)
       sums(2) = sums(2) + sum((tf_Sf-tf_Sc).^2); % ... and its Square
       sums(3) = sums(3) + sum((tf_Sf-tf_Sc).^3); % ... + Higher-Order Moments
       sums(4) = sums(4) + sum((tf_Sf-tf_Sc).^4); % ... + Higher-Order Moments                    
       sums(5) = sums(5) + sum(tf_Sf);  % Also, just the 'Fine' Piece
       sums(6) = sums(6) + sum(tf_Sf.^2); % ... and its Square       
    end % End Loops for 'n' Chunks of Sample Constructions
             
    % Final Step in Constructing the Estimator and its other Moments
    LEs_moments = sums./N;
    
end
