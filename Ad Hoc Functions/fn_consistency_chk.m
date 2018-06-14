% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function [chk_value] = fn_consistency_chk(level_estimators,fine_estimators,var_level_estimators,var_fine_estimators,l,N)
% Consistency Check re pp.22-23 (Giles 2015)

    chk_value = abs(level_estimators(l+1) + fine_estimators(l) - fine_estimators(l+1)) ...
      / ( 3.0*(sqrt(var_level_estimators(l+1)) + sqrt(var_fine_estimators(l)) + sqrt(var_fine_estimators(l+1)) ) ...
      / sqrt(N));

end

