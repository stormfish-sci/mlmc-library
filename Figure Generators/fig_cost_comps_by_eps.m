% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function fig_cost_comps_by_eps(i,stdm_cost,mlmc_cost,eps_vec)
% Plots Number of Samples Required At Each Level (where Number of Levels is
% Determined by Eps) for a Vector of Eps
        
    figure(i)
    loglog(eps_vec,eps_vec.^2.*stdm_cost,eps_vec,eps_vec.^2.*mlmc_cost)
    xlabel('Accuracy \epsilon'); ylabel('\epsilon^2 Cost');
    xticks(eps_vec);
    axis 'tight'

    legend('Std MC','MLMC','Location','NorthEast')    
    
end

