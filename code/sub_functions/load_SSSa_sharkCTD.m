%% load_SSSa_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load SSS monthly average anomaly data 
% for September. 

%% Load sea surface salinity anomaly data.

filename = 'OISSS_L4_multimission_global_monthly_v1.0_2015-09.nc';

sss.lon = ncread([folder '/data/satellite/' filename],'longitude');
sss.lat = ncread([folder '/data/satellite/' filename],'latitude');
sss.anom = ncread([folder '/data/satellite/' filename],'sss_anomaly');

clear filename

