% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function [levels_by_eps,n_per_level_by_eps,P_by_eps,l_costs_by_eps] = mlmc_optimize_multiple(eps_vec,...
    iminL,imaxL,L_max_allowed,N0,alpha,beta,gamma,thrw_perc,estimate_parameters_complexity,display_parameters_complexity,...
    level_fn,level_params,trans_fname,trans_params,cost_fn)
% Runs MLMC, Optimizing over L and N(l) to Meet a Desired Eps Value for
% Multiple Values of Eps. Returns Results and Displays Basic Info to Screen

    % Number of Samples/Paths Required at Each Level by Specified Eps Value
    % - Rows Contain Values for Levels L0,...,L; Matrix is Concatenated Horizontally by Eps Value
    n_per_level_by_eps = []; 
    % Values for L0,...,L by Specified Eps Value
    % - Rows Contain Level Values for Levels L0,...,L; Matrix is Concatenated Horizontally by Eps Value
    levels_by_eps  = []; 
    % Values for Estimated P
    % - Row Vector, by Eps Value
    P_by_eps = [];
    % Values for Level Costs for L0,...,L by Specified Eps Value
    % - Rows Contain Level Costs for Levels L0,...,L; Matrix is Concatenated Horizontally by Eps Value
    l_costs_by_eps  = []; 
    
    % Performs MLMC for Eps Value(s) Specified in Config File
    for i = 1:length(eps_vec)

        eps_i = eps_vec(i);

        % MLMC Driver Function                                            
        [P,minL,maxL,n_per_level,l_costs] = mlmc_optimize(eps_i,iminL,imaxL,L_max_allowed,N0,estimate_parameters_complexity,display_parameters_complexity,alpha,beta,gamma,thrw_perc,level_fn,level_params,trans_fname,trans_params,cost_fn);

        % Stores N's and L's by Eps
        n_per_level_by_eps(1:length(n_per_level),i) = n_per_level;
        levels_by_eps(1:length(n_per_level),i)  = minL:maxL;
        P_by_eps(i) = P;
        l_costs_by_eps(1:length(n_per_level),i) = l_costs;

    end

end