% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function [mlmc_costs,stdm_costs] = costs_compare_geo(eps_vec,P_by_eps,n_per_level_by_eps,levels_by_eps,level_params,var_fine_estimators)
% Compares Computational Costs b/w MLMC and Standard MC for Geometric-Based Timesteps

    M = level_params(1); % Geometric Level Factor
    % Computational Cost Storage Variables
    mlmc_costs = zeros(length(eps_vec),1); % Initializes Vector to Store Computational Costs for MLMC Method Calculations by Eps
    stdm_costs = zeros(length(eps_vec),1); % Initializes Vector to Store Computational Costs for Standard MC Method Calculations by Eps    
    % Display Results to Screen (Header)
    fprintf('\n Complexity Tests/Comparisons for Desired Eps Value(s): ');
    fprintf('\n ------------------------------------------------------');
    for i = 1:length(eps_vec) 
        minL = levels_by_eps(1,i); % Gets Coarsest L by Eps
        maxL = max(levels_by_eps(:,i)); % Gets Max Found L by Eps
        % Stores Computational Costs for MLMC and Standard MC by Eps
        mlmc_costs(i) = (1+1/M)*sum(n_per_level_by_eps(1:maxL-minL+1,i)'.*M.^(minL:maxL));
        stdm_costs(i)  = sum((2*var_fine_estimators(end)/eps_vec(i)^2).*M.^(minL:maxL)); 
%         mlmc_costs(i) = ((1+1/M)*sum(n_per_level_by_eps(2:maxL-minL+1,i)'.*M.^(minL+1:maxL)) + n_per_level_by_eps(1,i)'.*M.^(minL));
        % Outputs Info on Computational Cost Comparisons
        fprintf('\n - eps = %6.4f P = %8.4f MLMC v. Standard MC Savings Factor: %6.4f',eps_vec(i),P_by_eps(i),stdm_costs(i)/mlmc_costs(i));  
    end
    fprintf('\n');   

end