%% load_SSTa_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load SST anomaly data.

%% Load sea surface temperature anomaly data.

filename = 'erdAGtanm14day_LonPM180_6c0a_4534_ddfd.mat';

load([folder '/data/satellite/' filename]);

sst.lon = erdAGtanm14day_LonPM180.longitude;
sst.lat = erdAGtanm14day_LonPM180.latitude;

sst.time = erdAGtanm14day_LonPM180.time;
sst.time = datetime(datestr(sst.time/86400 + 719529));
sst.time.TimeZone = 'UTC';

sst.anom = erdAGtanm14day_LonPM180.sstAnomaly;
sst.anom = squeeze(sst.anom);

clear filename
clear erdAGtanm14day_LonPM180
