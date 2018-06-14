% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function [cost_calculation] = cost_fsteps_geo(l,N,level_params,time_toc)
% Returns Cost Calculation Using the Number of Fine Time Steps, Geometric

    M = level_params(1);
    cost_calculation = N*(M^l);
    
end

