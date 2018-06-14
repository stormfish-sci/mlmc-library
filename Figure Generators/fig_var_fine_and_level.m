% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function fig_var_fine_and_level(i,L0,L,var_fine_estimators,var_level_estimators)
% Plots Log(2) Variance for Estimates from Fine Level Only [P(l)] and the 
% Level Estimator [P(l)-P(l-1)] by Level

    figure(i)
    plot(L0:L,log2(abs(var_fine_estimators)),L0+1:L,log2(abs(var_level_estimators(2:end))))
    axis([L0 L -inf inf])
    xticks(L0:L)
    axis 'auto y'
    xlabel('Level l'); ylabel('log_2 |mean|');
    legend('P_l','P_l- P_{l-1}','Location','SouthWest')
    
end

