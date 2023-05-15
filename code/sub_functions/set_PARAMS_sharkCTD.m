%% set_PARAMS_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; set constants for depth correction, 
% dive detection and profile extraction.

%% For depth correction:

% Note, values of K need to change based on sampling frequency.
PARAMS.depth.K(1) = minutes(4); % window length for filter #1 (in minutes) (4 minutes)
PARAMS.depth.K(2) = days(30); % window length for filter #2 (in days) (30 days)

PARAMS.depth.P = 0.01; % quantile for filter #2

%% For dive detection:

PARAMS.dive.d_noise = 5; % meters, set values less than 5 m to 0 m
PARAMS.dive.prm = [15 5]; % prominence of local minimums and maximums

%% For profile extraction:

PARAMS.pfl.d_interp = 1; % interpolate profile at 1-m resolution