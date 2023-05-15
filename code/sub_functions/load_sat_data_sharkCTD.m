%% load_sat_data_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load absolute dynamic topography,
% sea-level anomaly, and geostrophic velocity anomalies.

%% Load satellite oceanographic data.

filename = 'cmems_obs-sl_glo_phy-ssh_my_allsat-l4-duacs-0.25deg_P1D_1662760812891.nc';

sat.lon = ncread([folder '/data/satellite/' filename],'longitude');
sat.lat = ncread([folder '/data/satellite/' filename],'latitude');

sat.time = ncread([folder '/data/satellite/' filename],'time');
sat.time = datetime(1950,01,01,00,00,00) + days(sat.time);
sat.time.TimeZone = 'UTC';

sat.adt = ncread([folder '/data/satellite/' filename],'adt');
sat.sla = ncread([folder '/data/satellite/' filename],'sla');
sat.vgosa = ncread([folder '/data/satellite/' filename],'vgosa');
sat.ugosa = ncread([folder '/data/satellite/' filename],'ugosa');

clear filename