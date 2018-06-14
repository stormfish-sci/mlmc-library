% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function fig_level_and_n_by_eps(i,levels_by_eps,n_per_level_by_eps,eps_vec)
% Plots Number of Samples Required At Each Level (where Number of Levels is
% Determined by Eps) for a Vector of Eps
    
    figure(i)
    semilogy(levels_by_eps,n_per_level_by_eps)
    axis([min(levels_by_eps(1,:)) max(max(levels_by_eps)) -inf inf])
    xticks(min(levels_by_eps(1,:)):max(max(levels_by_eps)));
    axis 'auto y'
    xlabel('Level l'); ylabel('Number of Samples');
    legend(num2str(eps_vec))     
    
end

