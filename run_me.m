% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

% -------------------------------------------------------------------------
% Runs Two Kinds of MLMC Simulations for Options Specified in Config File:
%
% - 1. Runs MLMC on N Samples using L Levels
%      -- Estimates MLMC Theorem Parameters
%      -- Graphs (Convergence) Results by Plotting Mean/Var of Level Est's
%      -- Additional Graphs for Consistency/Error Checking
% - 2. Runs MLMC Optimizing for L Levels and N(l) Samples for Specified Eps
%      -- Plots Level and N by Eps
%      -- Plots Comp. Cost Comparisons between MLMC and Standard MC by Eps
%
% - To Run: Type >>run_me and Select Config File from GUI Pop-up
%
% - DO NOT Change this Code or Any Code in the Existing Supplementary Files
%   in Attempts to Configure Application Variations; do so ONLY through the
%   Config Files! Additional Functions for Different Level Estimators and
%   Transform Functions may be Added as Applications Require
%
%   Note: Different MLMC Applications may Require Intermediate Solutions
%   and Transforms of those Solutions to a Final/Desired Output/Solution.
%   This Code Base is Modularized so that Function Files for Generic
%   Intermediate Solutions and Transforms can be Held in Folders so that
%   each Application can be Configured in a Separate Config File.
%    
% - Adapted from Mike Giles: http://people.maths.ox.ac.uk/gilesm/
%
% - Note: This 'run_me.m' Will Replicate the Analysis and Graphs as on
%   on pp. 31-33 of Giles(2015).
%
% -------------------------------------------------------------------------

clear; clc;

% Adds Folder Paths for Auxillary and Supplemental Files
% -------------------------------------------------------------------------
addpath(strcat(pwd,'\Driver Functions')); % Main MLMC Driver Function(s)
addpath(strcat(pwd,'\Config Files')); % Scripts that Set/Define the Application
addpath(strcat(pwd,'\Level Estimators')); % Functions Constructing the Intermediate Solution Space; e.g., GBM SDE's with scalar outputs
addpath(strcat(pwd,'\Transform Functions')); % Functions Constructing the Output Space; e.g. a 'Payoff' Function interpreting a GBM SDE as the Underlying for a Euro Call
addpath(strcat(pwd,'\Cost Functions')); % User-Specified Funtions to determine Computational Cost    
addpath(strcat(pwd,'\Ad Hoc Functions')); % Any Additional User-Specified Auxillary Functions
addpath(strcat(pwd,'\Graphics Profiles')); % Definitions for Basic/Default Graphics Properties
addpath(strcat(pwd,'\Figure Generators')); % Functions Files to Generate Typical/Standard Figures

% Runs the Config File to Populate Parameters and Options
% -------------------------------------------------------------------------
% Prompts with GUI for File Selection if no Config File Specified. 
% - If No File Selected, Will Exit Program
try
    % Converts (Entered) File Name to Function Handle
    config_fn = str2func(regexprep(config_fname,'\.m$',''));        
catch
    try
        % Prompts for Config File Selection
        [config_fname,config_path] = uigetfile('*.m','Select Config File:'); 
        % Adds Path of Config File (for Current Session Only)
        addpath(config_path);
        % Converts (Selected) File Name to Function Handle
        config_fn = str2func(regexprep(config_fname,'\.m$',''));        
    catch
        % Error Handling: No Valid Config File Specified.
        clear; clc;
        disp('No Config File Specified... Exiting.')
        return         
    end    
end

% Runs Configuration File to Populate Parameters and Options
config_fn()    
 
% Converts Name of Function for Level Estimator Specified in Config
% File to a Function Handle
level_fn = str2func(regexprep(level_fname,'\.m$','')); 

% Converts Name of Function for Computational Cost Determination 
% Specified in Config File to a Function Handle
try
    cost_fn = str2func(regexprep(cost_fname,'\.m$','')); 
catch
    cost_fn = str2func('cost_toc.m','\.m$',''); % Uses Time as Default
end

% Converts Name of Script Specifying Graphics Profile to a Function Handle
try
    graphics_script = str2func(regexprep(graphics_sname,'\.m$','')); 
catch
    graphics_script = str2func('graphics_basic_color.m','\.m$',''); % Uses Basic Color Option as Default
end    
graphics_script()    

% 1.) Runs Basic MLMC for N Samples on L0,...,L Levels 
% -------------------------------------------------------------------------

% Runs Basic Routine and (Optionally) Estimates MLMC Theorem Parameters
[level_estimators,fine_estimators,var_level_estimators,var_fine_estimators,...
    consistency_checks,level_kurtosis,level_costs,alpha,beta,gamma] = mlmc_basic(L0,L,N,max_kurtosis_value,...
    max_consistency_chk_value,estimate_parameters,display_parameters,alpha,beta,gamma,...
    thrw_perc,level_fn,level_params,trans_fname,trans_params,cost_fn);

% From Results, Makes Four Figures at Figure Handle Specified in FID; Skips if Zero
if fid(1) ~= 0
    fig_var_fine_and_level(fid(1),L0,L,var_fine_estimators,var_level_estimators)
end
if fid(2) ~= 0
    fig_mean_fine_and_level(fid(2),L0,L,fine_estimators,level_estimators)
end
if fid(3) ~= 0 % Error Checking
    fig_consistency_chk(fid(3),L0,L,consistency_checks)
end
if fid(4) ~= 0 % Error Checking
    fig_kurtosis_chk(fid(4),L0,L,level_kurtosis)
end

% 2. Runs MLMC Optimizing for L Levels and N(l) Samples for Specified Eps
% -------------------------------------------------------------------------

% Runs Estimation/Optimization Routine and (Optionally) Estimates MLMC
% Theorem Parameters On-the-Fly if Necessary
 [levels_by_eps,n_per_level_by_eps,P_by_eps,l_costs_by_eps] = mlmc_optimize_multiple(eps_vec,...
    iminL,imaxL,L_max_allowed,N0,alpha,beta,gamma,thrw_perc,estimate_parameters_complexity,display_parameters_complexity,...
    level_fn,level_params,trans_fname,trans_params,cost_fn);

% From Results, Makes Figure at Figure Handle Specified in FID; Skips if Zero
if fid(5) ~=0
    fig_level_and_n_by_eps(fid(5),levels_by_eps,n_per_level_by_eps,eps_vec)
end

% 3. Compares Computational Costs between MLMC and Standard MC 
% -------------------------------------------------------------------------

% Converts Name of Function for Computational Cost Comparisons
% Specified in Config File to a Function Handle
costs_compare_fn = str2func(regexprep(costs_compare_fname,'\.m$','')); 

% Uses Results from Runs in (1) and (2) Above to Compute Costs and Compare
[mlmc_costs,stdm_costs] = costs_compare_fn(eps_vec,P_by_eps,n_per_level_by_eps,levels_by_eps,level_params,var_fine_estimators);
    
% From Results, Makes Figure at Figure Handle Specified in FID; Skips if Zero
if fid(6) ~= 0
    fig_cost_comps_by_eps(fid(6),stdm_costs,mlmc_costs,eps_vec)
end

