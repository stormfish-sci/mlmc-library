% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function [level_estimators,fine_estimators,var_level_estimators,var_fine_estimators,...
    consistency_checks,level_kurtosis,level_costs,alpha,beta,gamma] = mlmc_basic(L0,L,N,max_kurtosis_value,...
    max_consistency_chk_value,estimate_parameters,display_parameters,alpha,beta,gamma,...
    thrw_perc,level_fn,level_params,trans_fname,trans_params,cost_fn)
% Runs Basic MLMC for N Samples on L0,...,L Levels and (Optionally) Estimates MLMC Theorem Parameters

    % Vectors of Length L Storing Level Estimate Info
    level_estimators = zeros(L-L0,1); % E[Y(l)]= E[P(l)-P(l-1)] for l = L0,...,L
    fine_estimators = zeros(L-L0,1); % E[P(l)] for l = L0,...,L
    var_level_estimators = zeros(L-L0,1); % V[Y(l)] for l = L0,...,L
    var_fine_estimators = zeros(L-L0,1); % V[P(l)] for l = L0,...,L
    consistency_checks = zeros(L-L0,1); % Consistency Check re pp.22-23 Giles (2015); [Pr(chk)>1]<0.3% (Indicates Error if Violated)
    level_kurtosis = zeros(L-L0,1); %  Moment-Based Kurtosis Calculation for Level Estimate (Used as Second Consistency Check)
    level_costs = zeros(L-L0,1); % User-Defined Conception of Calculation for Computational Costs

    % Runs MLMC on N Samples using L Levels to Run/Show Convergence Results
    for l = L0:L  

        % Gets Moments of Level Estimators
        tic;
        LE_moments = level_fn(l,N,level_params,trans_fname,trans_params); 
        toc_time = toc;

        % Stores Info of Level Estimators for Levels L0,...,L
        level_estimators(l-L0+1) = LE_moments(1);
        var_level_estimators(l-L0+1) = LE_moments(2)-LE_moments(1)^2;
        fine_estimators(l-L0+1) = LE_moments(5);
        var_fine_estimators(l-L0+1) = max(1e-12,LE_moments(6)-LE_moments(5)^2);
        if l > L0
            consistency_checks(l-L0+1) = fn_consistency_chk(level_estimators,fine_estimators,var_level_estimators,var_fine_estimators,l-L0,N);
        end        
        if l > L0
            level_kurtosis(l-L0+1) = fn_moment_kurtosis(LE_moments(1:4)); %
        end
        level_costs(l-L0+1) = cost_fn(l,N,level_params,toc_time);

    end

    % Check on Potential (likely, Coding/Specification) Error
    % - [Pr(chk)>1]<0.3% (Indicates Error if Violated)
    if max(consistency_checks) > max_consistency_chk_value
        fprintf('\n WARNING: Consistency Check Error; Max Essor = %4.2f',max(consistency_checks))
        fprintf('\n - Identity E[Pf-Pc] = E[Pf] - E[Pc] Not Satisfied.\n')
        cont_value = input(' - Continue? (yes/no) >> ','s'); % Prompts to Continue Running Program or Exit
        if not(strcmp(cont_value,'yes'))
            return
        end
    end

    % Check on Kurtosis Value at Max L
    % - Large Values Indicate Poor Empirical Sample Variance
    if level_kurtosis(end) > max_kurtosis_value
        fprintf('\n WARNING: Kurtosis on Max/Finest Level = %f \n',level_kurtosis(end))
        fprintf('\n - Empirical Sample Variance May be Poor..\n')
        cont_value = input(' - Continue? (yes/no) >> ','s'); % Prompts to Continue Running Program or Exit
        if not(strcmp(cont_value,'yes'))
            return
        end
    end    

    % Estimates MLMC Theorem Parameters: alpha, beta, and gamma on Flag
    if (estimate_parameters || min([alpha,beta,gamma]) <=0) && display_parameters
        % Estimates MLMC Theorem Parameters alpha, beta, and gamma
        [alpha,beta,gamma] = fn_est_mlmc_parameters(level_estimators,var_level_estimators,level_costs,L0,L,thrw_perc);
        % Display Results to Screen
        fprintf('\n Estimates of Key MLMC Theorem Parameters');
        fprintf('\n ----------------------------------------');
        fprintf('\n Using N = %i Samples on each L = %i,...,%i Level: ',N,L0,L)
        fprintf('\n - Weak Convergence:   alpha = %8.6f ',alpha)
        fprintf('\n - Variance:           beta  = %8.6f ',beta)
        fprintf('\n - Computational Cost: gamma = %8.6f \n',gamma)
    end

end