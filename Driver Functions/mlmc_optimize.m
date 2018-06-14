% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function [P,L0,L,ttl_N,level_costs] = mlmc_optimize(eps_i,iminL,imaxL,L_max_allowed,N0,estimate_parameters_complexity,display_parameters_complexity,alpha,beta,gamma,thrw_perc,level_fn,level_params,trans_fname,trans_params,cost_fn)
% Runs MLMC, Optimizing over L and N(l) to Meet a Desired Eps Value

    % Flag: Will Estimate MLMC Theorem Parameters On-the-Fly if Flagged to do So,
    % or if Values are Zero or Negative. (Otherwise, will use Parameter Values as Passed.
    if min([alpha,beta,gamma]) <=0
        estimate_parameters_complexity = true;
    end
    
    L0 = iminL; % Value for L0
    L = imaxL; % Initial/Starting Value for L
    
    nxt_N = N0.*ones(L-L0+1,1); % Additional Samples Needed per Level; Starts with N0 Samples
    ttl_N = zeros(L-L0+1,1); % Total Number of Samples Calculated per Level
    moments = zeros(L-L0+1,2); % First Two Moments of Values per Level
    level_costs = zeros(L-L0+1,1); % Level Costs
    
    % Starts by Calculating N0 Samples for Levels L0,...,L
    % ... Will Calculate Additional Samples/Levels as Needed/Indicated.
    while max(nxt_N) > 0        
       
        % Generate Sample Moments on Each Level
        for l = L0:L  
            if nxt_N(l-L0+1) > 0
                
                tic
                % Gets Moments of Level Estimates from Level Estimator Function
                le_moments = level_fn(l,nxt_N(l-L0+1),level_params,trans_fname,trans_params);
                toc_time = toc;
                
                % Appends Info to Cost Function
                level_costs(l-L0+1) = level_costs(l-L0+1) + cost_fn(l,nxt_N(l-L0+1),level_params,toc_time);
                
                % Stores First Two Moments (Only) Returned by Level Estimator Function
                moments(l-L0+1,1:2) = (moments(l-L0+1,1:2).*ttl_N(l-L0+1) + le_moments(1:2)'.*nxt_N(l-L0+1)) ./ (ttl_N(l-L0+1)+nxt_N(l-L0+1));
                
                % Adds to Count of Sample Numbers
                ttl_N(l-L0+1) = ttl_N(l-L0+1) + nxt_N(l-L0+1);
            end
        end
        
        % Constructs Abs Average and Variance Values for E|Y(l)| and V(Y(l))
        EY = abs(moments(:,1));
        VY = max(0,moments(:,2)-EY.^2);        
        
        % Estimates MLMC Theorem Parameters: alpha, beta, and gamma
        % - Continues to Re-Estimate with Additional on Increased Samples/Levels
        if estimate_parameters_complexity
            [alpha,beta,gamma] = fn_est_mlmc_parameters(EY,VY,(level_costs./ttl_N),L0,L,thrw_perc);
            % Potential Corrections for Early/Inaccurate Estimates on (Small) Sample Sizes
            alpha = max(0.5,alpha);
            beta = max(0.5,beta);
            gamma = max(0.5,gamma);
        end
        
        % Finds Optimal Number of Additional Samples per Level
        EC = (2.^(gamma*(L0:L)))';
        opt_N  = ceil(2 * sqrt(VY./EC) * sum(sqrt(VY.*EC)) / eps_i^2);
        nxt_N = max(0, opt_N-ttl_N);
        
        % If *Almost Converged, Checks if Additional Levels Req'd Given
        % Estimated Remaining Error and Comparison with Desired Eps Value
        if sum(nxt_N > 0.01*ttl_N) == 0 % If None of Opt Num of Additional Samples are > than 1% of Current N...
            
            % Estimates Remaining Error (Extrapolates over last Three
            % Levels and Takes the Max for Robustness)
            range = -2:0;
            rem_error = max(EY(L-L0+1+range).*(2.^(alpha*range))) / (2^alpha - 1); 
            
            % Checks for Convergence of Error against Desired Eps
            if rem_error > eps_i/sqrt(2)
                
                if L == L_max_allowed % Preventing Infinite Run-Time for Non-Convergence/Adding Infinite Levels...
                    
                    fprintf('\n Failed to Achieve Weak Convergence for Eps = %f. Max Level Exceeded.',eps_i);

                else
                
                    L = L + 1; % Adds a Level if Convergence Test not Satisfied

                    % Appends Initializations to Storage Variables for level L+1
                    ttl_N = [ttl_N; 0]; 
                    moments = [moments; 0 0]; 
                    level_costs = [level_costs; 0]; 

                    % Constructs Initial/Optimal N for New Level
                    VY_Lplus = VY((L-1)-L0+1)/(2^beta); % Extrapolates Variance to L+1 (to Construct Opt N for L+1)
                    EC_Lplus = 2^(gamma*L); % Level Cost Estimate for L+1 (to Construct Opt N for L+1)
                    nxt_N = [nxt_N; max(0,ceil(2*sqrt(VY_Lplus/EC_Lplus)*sum(sqrt(VY_Lplus.*EC_Lplus))/eps_i^2))];
                    
                end
                
            end
            
        end
        
    end
    
    P = sum(EY); % Constructs Value Estimate from MLMC Method
    
    % Display for Final Estimation of MLMC Theorem Parameters if Specified
    if estimate_parameters_complexity && display_parameters_complexity
        % Estimates MLMC Theorem Parameters alpha, beta, and gamma
        [alpha,beta,gamma] = fn_est_mlmc_parameters(EY,VY,(level_costs./ttl_N),L0,L,thrw_perc);
        % Display Results to Screen
        fprintf('\n Estimates of Key MLMC Theorem Parameters using L = %i,...,%i Levels with a total of N = %i across all Levels for a Tolerance of eps = %5.4f: ',L0,L,sum(ttl_N),eps_i)
        fprintf('\n - Weak Convergence:   alpha = %8.6f ',alpha)
        fprintf('\n - Variance:           beta  = %8.6f ',beta)
        fprintf('\n - Computational Cost: gamma = %8.6f \n',gamma)
    end    
    
end
    
    