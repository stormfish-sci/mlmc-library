% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function fig_consistency_chk(i,L0,L,consistency_checks)
% Plots Consistency Check Values by Level
% - [Pr(chk)>1]<0.3% (Indicates Error if Violated): If Values > 1, Look for
%   Coding or Specification Error.
    
    figure(i)
    plot(L0+1:L,consistency_checks(2:end))
    axis([L0+1 L -inf inf])
    xticks(L0+1:L)
    axis 'auto y'
    xlabel('Level l'); ylabel('Consistency Check');    
    
end

