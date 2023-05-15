%% calc_dive_spacing_PAT_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; calculate full-depth Rossby
% deformation radius for recoverd PAT tags.
% 
% For a baroclinic ocean, the full-depth Rossby deformation radius (R_d_full) 
% is defined as:
% 
% R_d_full = c/f, 
% 
% where c is the baroclinic gravity-wave phase speed and f is the Coriolis paramater.
% 
%% Only keep profiles within the Gulf of Alaska.

dr = vertcat(pfl.PAT.DepthRange);
lon = [pfl.PAT.Longitude].'; lat = [pfl.PAT.Latitude].';

ind_lon = lon <= -125 & lon >= -150; ind_lat = lat >= 50 & lat <= 60;
ind = ind_lon + ind_lat == 2;

%% Interporlate c1 and estimate c at each shark TD profile.

rossby.c_TD = rossby.F(lon(ind),lat(ind));

%% Compute Coriolis parameter at each shark TD profile.

rossby.f_TD = gsw_f(lat(ind)); % 1/seconds

%% Calculate baroclinic full-depth Rossby deformation radius.

spacing.full_TD_m = rossby.c_TD./rossby.f_TD; % meters
spacing.mean_full_TD_km = mean(spacing.full_TD_m(dr(ind) >= 100),'omitnan')./1000; % kilometers
spacing.std_full_TD_km = std(spacing.full_TD_m(dr(ind) >= 100),'omitnan')./1000;

%% Clear

clear dr
clear ind*
clear lat
clear lon