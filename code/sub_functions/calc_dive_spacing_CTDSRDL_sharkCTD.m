%% calc_dive_spacing_CTDSRDL_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; calculate full-depth Rossby
% deformation radius.
% 
% For a baroclinic ocean, the full-depth Rossby deformation radius (R_d_full) 
% is defined as:
% 
% R_d_full = c/f, 
% 
% where c is the baroclinic gravity-wave phase speed and f is the Coriolis paramater.
% 
%% Load first baroclinic gravity wave speeds (c1). 
% Calculated from CSIRO Atlas of Regional Seas Climatology (CARS2009) 
% temperature and salinity fields following the method of Chelton et al. 
% (Journal of Physical Oceanography, 1998). Data are provided on a 0.5 
% degree grid in latitude and longitude.

rossby = load([folder '/data/rossby/Rossby_radius.mat'],'c1','lon','lat');
rossby.lon = wrapTo180(rossby.lon);

%% Interporlate c1 and estimate c at each shark profile.

[rossby.x,rossby.y] = meshgrid(rossby.lon,rossby.lat);
rossby.F = scatteredInterpolant(rossby.x(:),rossby.y(:),rossby.c1(:));
rossby.c = rossby.F(shark.corr.lon,shark.corr.lat);

%% Compute Coriolis parameter at each shark profile.

rossby.f = gsw_f(shark.corr.lat); % 1/seconds

%% Calculate baroclinic full-depth Rossby deformation radius.

spacing.full_m = rossby.c./rossby.f; % meters
spacing.mean_full_km = mean(spacing.full_m,'omitnan')./1000; % kilometers
spacing.std_full_km = std(spacing.full_m,'omitnan')./1000;

