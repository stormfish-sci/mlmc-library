% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function [alpha,beta,gamma] = fn_est_mlmc_parameters(level_estimators,var_level_estimators,level_costs,L0,L,thrw_perc)
% Estimates MLMC Theorem Parameters alpha, beta, and gamma from Linear
% Regression for alpha and beta and Ratios of the Final Two Levels for 
% gamma Based on Sample Data from L-L0 Levels

    thrw = ceil(thrw_perc*(L-L0)); % Observations/Levels to 'Throw Away', Given Less Accurracy on Lower Levels    

    beta_cfs = polyfit((L0+thrw:L)',log2(abs(level_estimators(thrw+1:L-L0+1))),1);
    alpha = -beta_cfs(1);
    
    beta_cfs = polyfit((L0+thrw:L)',log2(abs(var_level_estimators(thrw+1:L-L0+1))),1);
    beta = -beta_cfs(1);
    
    gamma = log2(level_costs(end)/level_costs(end-1));
        
end

