%% load_argos_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; loads ARGOS positions from CTD-SRDL
% shark fin tag.

%% Load ARGOS data.

cd([folder '/data/ctd/1715013_13219/database'])
load('diag.mat');

argos.date = D_DATE; % date & time
argos.date.TimeZone = 'UTC'; argos.date.TimeZone = 'America/Los_Angeles';

argos.lat = LAT; % degrees North
argos.lon = LON; % degrees East

argos.qual = LQ; % quality of ARGOS position estimate

%% Clear.

clear D_DATE LAT LON LQ