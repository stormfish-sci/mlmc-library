% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

% -------------------------------------------------------------------------
% Configuration File for MLMC Simulations
%
% This File: 
%
% European Call Option on a Single Underlying Asset with a GBM SDE:
% dSt = r*St*dt + sig*St*dW, with payoff: P(S) = exp(-rT)*max(ST-K,0)
%
% MLMC Simulations use a Euler-Maruyama Discretisation with Uniform 
% Time-Steps and Brownian Increments
% -------------------------------------------------------------------------

% General Settings
% -------------------------------------------------------------------------

% Controls Random Number Generation
rng('default'); % Currently, := rng(0,'twister') 

% User-Specified Graphics Profile (Black/Color/Etc.)
graphics_sname = 'graphics_basic_color'; % Basic Color / Line-Style Options

% Generates Figure Handles:
% 1 - Variance by Level
% 2 - Mean by Level
% 3 - Consistency Check
% 4 - Kurtosis Check
% 5 - Level and N by Eps
% 6 - Cost Comparisons by Eps
fid = [1,2,3,4,5,6]; % Set # of Figure Handles in Order; Set to '0' to Skip

% General MLMC Parameters (Application Agnostic)
% -------------------------------------------------------------------------

% 1. For Running MLMC on N Samples using L Levels
% ----------------------------------------
L0 = 0; % Coarsest Level
L = 8; % Maximum Number of Levels, min = 3
N = 100000; % Number of Samples/Paths on Each Level
max_kurtosis_value = 100; % Error Check: Large Values of Kurtosis on Max L Indicate Empirical Variance Estimates May be Poor
max_consistency_chk_value = 1.0; % Error Check: [Pr(chk)>1]<0.3% (Indicates Likely Coding/Specification Error if Violated)
estimate_parameters = true; % T/F to Optionally Estimate MLMC Theorem Parameters from Results
display_parameters = true; % T/F to Display the Above

% 2. For Running MLMC Optimizing for L and N(l) Samples over Eps
% --------------------------------------------------------------
iminL = 0; % Coarset Level
imaxL = 2; % Minimum Max Level to Try/Start With (2 is Min)
L_max_allowed = 100; % Max L at which to Stop Trying/Adding Additional Levels
N0 = 1000; % Min Number of Samples/Paths per Level to Try/Start With
eps_vec = [0.005; 0.01; 0.02; 0.05; 0.1]; % (Desired) Accuracy Levels 
estimate_parameters_complexity = false; % T/F to Estimate Parameters on-the-fly During MLMC Optimization Runs (Otherwise Uses Results from (1) or Entereted Values)
display_parameters_complexity = false; % T/F to Display Results of the Above

% Level Estimator Options and Parameters (Application Specific)
% -------------------------------------------------------------------------

% Level Estimator Function
level_fname = 'level_sde_gbm_euler'; % GBM SDE with Euler-Maruyama Discretisation

% MLMC Theorem Parameter Values
alpha = 0; % (Zero Values will Trigger Parameter Estimation During Runs)
beta = 0; % (Zero Values will Trigger Parameter Estimation During Runs)
gamma = 0; % (Zero Values will Trigger Parameter Estimation During Runs)
thrw_perc = 0.2; % Percentage of Levels/Observations to 'Throw Away' When/If Estimating MLMC Parameters: alpha, beta, gamma

% Factor by which the Timestep is Refined at each Level
M = 2; % Geometric Level Factor; i.e. M^l time-steps on Level l, note: M=2^gamma in General MLMC Theorem

% Parameter Values
mu = 0.05; % Percentage Drift (Rf in this Case, so r=mu in a Generic SDE)
sig = 0.2; % Percentage Volatility
S0 = 100; % Initial Value
T = 1; % Time Interval, where t = 0...T (in this Case, T is the Maturity)

% Vector of all Parameters
level_params = [M,mu,sig,S0,T];

% User-Specified Cost Function(s)
cost_fname = 'cost_fsteps_geo'; % Uses Number of Fine Timesteps (Geometric)
costs_compare_fname = 'costs_compare_geo'; % Used in Computational Comparisons for MLMC v. Standard

% Transform Function Options and Parameters (Application Specific)
% -------------------------------------------------------------------------

% Transform Function
trans_fname = 'trans_european_call'; % European Call Option

% Parameter Values
K = 100; % Strike Price in the Payoff Function

% Vector of all Parameters
trans_params = [mu T K];

% End ---------------------------------------------------------------------


