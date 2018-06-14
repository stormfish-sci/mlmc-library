% *************************************************************************
% Developed for Stormfish Scientific Corporation
% by Sherry Lauren Forbes, Ph.D.
% *************************************************************************

% -------------------------------------------------------------------------
% This Code Base Does the Following:
%
% Runs Two Kinds of MLMC Simulations for Options Specified in Config File:
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
% - The Included 'run_me.m' File will Reproduce the Analysis and Graphs as
%   on pp. 31-33 of Giles(2015). The Included Configuration File will
%   Perform Analysis on a GBM SDE as on p. 31 ('config_sde_gbm_euler.m').
%
% - Adapted from Mike Giles: http://people.maths.ox.ac.uk/gilesm/
%
% - Instructions below Specify How the Code can be Adapted for Additional
%   Applications...
%
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% How to Set Up a Configuration File and How to Create Auxillary Files
%
% - See 'config_sde_sbm_euler.m' as an Example.
%
% - A Config File Should Follow the Structure Below:
%
% General Settings
% -------------------------------------------------------------------------
%
% * Set an Option to Control Random Number Generation
% * Select a 'Graphics Profile'
% * Set Figure Handle Numbers for Each of the Six Figures Generated. Set
%   '0' to Skip a Figure. 
%
% General MLMC Parameters (Application Agnostic)
% -------------------------------------------------------------------------
%
% * Set Values for Part 1 for Running N Samples on L0,...,L Levels:
%   N,L0,L,etc. Choose to Use MLMC Parameters as Entered, or Estimate
% * Set Values for Part 2 for Optimizing N and L for Values of Eps:
%   iminL,imaxL,N0,eps_vec,etc. Choose Option to Use MLMC Parameters as 
%   Entered/Estimated from Step 1 or Estimate On-the-Fly
%
% Level Estimator Options and Parameters (Application Specific)
% -------------------------------------------------------------------------
%
% * Specify the Name of the Function File for the Level Estimator
% * Set Values for General MLMC Parameters alpha,beta,gamma
% * Specify the Parameter Values Needed by the Level Estimator
% * Specify a Vector Including all the Above Parameters
% * Specify Name of Function File Used to Determine Computational Cost. 
%   No Specification will Use Default=toc. 
%
% Transform Function Options and Parameters (Application Specific)
% -------------------------------------------------------------------------
%
% *Note: Specification of a Transform Function is Optional. If No Function
% Specified, the Output/Result from Level Estimator will be Interpreted as
% the 'Final' Output Desired.
%
% * Specify the Name of the Function File for the Transform Function
% * Specify the Parameter Values needed by the Transform Function
% * Specify a Vector including all the Above Parameters
%
% End Config File ---------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%
% Note: Supplementary Function Files Should be Dropped in Appropriate
% Folders; but because the Paths of all of these Folders are added to the
% Current Workspace, Naming Conventions Should be Followed so as not to
% Duplicate Functions/Files.
%
% Config Files: Drop in Folder 'Config Files'.
% - Naming Convention: 'config_<name>.m'
% - Inputs: None.
%
% Graphis Profiles: Drop in Folder 'Graphics Profiles'.
% - Naming Convention: 'graphics_<name>.m'
% - Inputs: None.
%
% Figure Generators: Drop in Folder 'Figure Generators'.
% Naming Convention: 'fig_<name>.m'
% - Inputs: Can be Varied, but Should Specify Figure Handle.
%
% Driver Functions: Drop in Folder 'Driver Functions'.
% Naming Convention: 'mlmc_<name>.m'
% - Inputs: Can be Varied.
%
% Level Estimators: Drop in Folder 'Level Estimators'.
% Naming Convention: 'level_<name>.m'
% - Inputs: l,M,N,level_params,trans_fname,trans_params
%
% Transform Functions: Drop in Folder 'Transform Functions'.
% Naming Convention: 'trans_<name>.m'
% - Inputs: values,trans_params
%
% Cost Functions: Drop in Folder 'Cost Functions'.
% Naming Convention: 'cost_<name>.m'
% - Inputs: l,N,level_params,toc (All Reqd, even if Not Used.)
%
% Costs Compare Functions: Drop in Folder 'Cost Functions'.
% Naming Convention: 'costs_compare_<name>.m'
% - Inputs: eps_vec,P_by_eps,n_per_level_by_eps,levels_by_eps,level_params,var_fine_estimators (All Reqd, even if Not Used.)
%
% Ad Hoc Functions: Drop in Folder 'Ad Hoc Functions'.
% Naming Convention: 'fn_<name>.m'
% - Inputs: Can be Varied.
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------