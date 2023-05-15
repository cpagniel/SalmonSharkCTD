%% load_WOA_clims_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load 1981-2010 monthly objectively 
% analyzed temperature and salinity climatologies from the World Ocean 
% Atlas 2018 on 1/4 deg grid.

%% Load temperature climatology.

load([folder '/data/woa/' 'woa18_decav81B0_t08an04.mat']);
load([folder '/data/woa/' 'woa18_decav81B0_t09an04.mat']);

anom.clim.T.August = August;
anom.clim.T.September = September;

clear August September

%% Load Salinity climatology.

load([folder '/data/woa/' 'woa18_decav81B0_s08an04.mat']);
load([folder '/data/woa/' 'woa18_decav81B0_s09an04.mat']);

anom.clim.S.August = August;
anom.clim.S.September = September;

clear August September