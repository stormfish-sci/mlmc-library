% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

function [calculated_kurtosis] = fn_moment_kurtosis(moments)
%Moment-Based Kurtosis Calculation

    M1 = moments(1);
    M2 = moments(2);
    M3 = moments(3);
    M4 = moments(4);

    calculated_kurtosis = (M4 - 4*M3*M1 + 6*M2*M1^2 - 3*M1^4) / (M2-M1^2)^2;


end

