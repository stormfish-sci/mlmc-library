% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function fig_kurtosis_chk(i,L0,L,level_kurtosis)
% Plots Kurtosis Check Values by Level
% - Large Values Indicate Poor Empirical Sample Variance
    
    figure(i)
    plot(L0+1:L,level_kurtosis(2:end))
    axis([L0+1 L -inf inf])
    xticks(L0+1:L)
    axis 'auto y'
    xlabel('Level l'); ylabel('Kurtosis');       
    
end

