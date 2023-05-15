%% load_eddies_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load anticyclonic and cyclonic eddy
% contours.

%% Set timezones of all datasets to UTC.

shark.corr.datetime.TimeZone = 'UTC';
argos.time.TimeZone = 'UTC';

%% Define study area.

LATLIMS = [50 60]; LONLIMS = [-150 -125];
bndry = [LONLIMS(1) LONLIMS(1)...
    LONLIMS(2) LONLIMS(2)...
    LONLIMS(1);...
    LATLIMS(1) LATLIMS(2)...
    LATLIMS(2) LATLIMS(1)...
    LATLIMS(1)];
clear *LIMS

%% Load anticyclonic mesoscale eddy atlases (i.e., long, short and untracked) from AVISO.

% Anticyclonic - Long (i.e., > 10 days)
filename = 'META3.2_DT_allsat_Anticyclonic_long_19930101_20220209.nc';

cd([folder '/data/eddies/'])
tmp = ncread(filename,'time');
tmp = datetime('01/01/1950') + days(tmp);

% Make dates from AVISO and shark-collected CTD same format dd-mm-yyyy.
dd.AC.Date = datetime(year(tmp),month(tmp),day(tmp));
dd.META.Date = datetime(2015,08,13):datetime(2015,09,18);
dd.META.Date = dd.META.Date.';

% Index of AC dates in metadata.
ind = ismember(dd.AC.Date,dd.META.Date);

eddies.AC = table(tmp(ind),'VariableNames',{'Date'});

clear tmp*

% Load Remaining Variables
tmp = ncread(filename,'amplitude'); % in meters
eddies.AC.Amplitude = tmp(ind);

tmp = ncread(filename,'effective_contour_latitude');
tmp = tmp(:,ind);
tmp = num2cell(tmp,1);
eddies.AC.EffectiveContourLatitude = tmp.';

tmp = ncread(filename,'effective_contour_longitude'); % degrees E
tmp = wrapTo180(tmp(:,ind)); % degrees W
tmp = num2cell(tmp,1);
eddies.AC.EffectiveContourLongitude = tmp.';

tmp = ncread(filename,'effective_radius'); % in meters
eddies.AC.EffectiveRadius = tmp(ind);

tmp = ncread(filename,'latitude');
eddies.AC.EffectiveCenterLatitude = tmp(ind);

tmp = ncread(filename,'longitude'); % degrees E
eddies.AC.EffectiveCenterLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'speed_radius'); % in meters
eddies.AC.SpeedRadius = tmp(ind);

tmp = ncread(filename,'speed_average'); % in meters/second
eddies.AC.SpeedAverage = tmp(ind);

tmp = ncread(filename,'latitude_max');
eddies.AC.SSHMaxLatitude = tmp(ind);

tmp = ncread(filename,'longitude_max'); % degrees E
eddies.AC.SSHMaxLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'observation_number');
eddies.AC.DaysSinceFirstDetection = tmp(ind);

tmp = ncread(filename,'track');
eddies.AC.TrajectoryID = tmp(ind);

clear tmp
clear ind

ind = inpolygon(eddies.AC.SSHMaxLongitude,eddies.AC.SSHMaxLatitude,bndry(1,:),bndry(2,:));

eddies.AC = eddies.AC(ind,:);

clear ind

% Anticyclonic - Short (i.e., < 10 days)
filename = 'META3.2_DT_allsat_Anticyclonic_short_19930101_20220209.nc';

tmp = ncread(filename,'time');
tmp = datetime('01/01/1950') + days(tmp);

% Make dates from AVISO and shark-collected CTD same format dd-mm-yyyy.
dd.AC.Date = datetime(year(tmp),month(tmp),day(tmp));

% Index of AC dates in metadata.
ind = ismember(dd.AC.Date,dd.META.Date);

short = table(tmp(ind),'VariableNames',{'Date'});

clear tmp*

% Load Remaining Variables
tmp = ncread(filename,'amplitude'); % in meters
short.Amplitude = tmp(ind);

tmp = ncread(filename,'effective_contour_latitude');
tmp = tmp(:,ind);
tmp = num2cell(tmp,1);
short.EffectiveContourLatitude = tmp.';

tmp = ncread(filename,'effective_contour_longitude'); % degrees E
tmp = wrapTo180(tmp(:,ind)); % degrees W
tmp = num2cell(tmp,1);
short.EffectiveContourLongitude = tmp.';

tmp = ncread(filename,'effective_radius'); % in meters
short.EffectiveRadius = tmp(ind);

tmp = ncread(filename,'latitude');
short.EffectiveCenterLatitude = tmp(ind);

tmp = ncread(filename,'longitude'); % degrees E
short.EffectiveCenterLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'speed_radius'); % in meters
short.SpeedRadius = tmp(ind);

tmp = ncread(filename,'speed_average'); % in meters/second
short.SpeedAverage = tmp(ind);

tmp = ncread(filename,'latitude_max');
short.SSHMaxLatitude = tmp(ind);

tmp = ncread(filename,'longitude_max'); % degrees E
short.SSHMaxLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'observation_number');
short.DaysSinceFirstDetection = tmp(ind);

tmp = ncread(filename,'track');
short.TrajectoryID = tmp(ind);

clear tmp
clear ind

% Only Keep Eddies Whose Centers in Within Study Area
ind = inpolygon(short.SSHMaxLongitude,short.SSHMaxLatitude,bndry(1,:),bndry(2,:));

short = short(ind,:);

clear ind

% Combine Long and Short AC Detections
eddies.AC = [eddies.AC; short];

clear short

% Anticyclonic - Untracked
filename = 'META3.2_DT_allsat_Anticyclonic_untracked_19930101_20220209.nc';

tmp = ncread(filename,'time');
tmp = datetime('01/01/1950') + days(tmp);

% Make dates from AVISO and shark-collected CTD same format dd-mm-yyyy.
dd.AC.Date = datetime(year(tmp),month(tmp),day(tmp));

% Index of AC dates in metadata.
ind = ismember(dd.AC.Date,dd.META.Date);

untracked = table(tmp(ind),'VariableNames',{'Date'});

clear tmp*

% Load Remaining Variables
tmp = ncread(filename,'amplitude'); % in meters
untracked.Amplitude = tmp(ind);

tmp = ncread(filename,'effective_contour_latitude');
tmp = tmp(:,ind);
tmp = num2cell(tmp,1);
untracked.EffectiveContourLatitude = tmp.';

tmp = ncread(filename,'effective_contour_longitude'); % degrees E
tmp = wrapTo180(tmp(:,ind)); % degrees W
tmp = num2cell(tmp,1);
untracked.EffectiveContourLongitude = tmp.';

tmp = ncread(filename,'effective_radius'); % in meters
untracked.EffectiveRadius = tmp(ind);

tmp = ncread(filename,'latitude');
untracked.EffectiveCenterLatitude = tmp(ind);

tmp = ncread(filename,'longitude'); % degrees E
untracked.EffectiveCenterLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'speed_radius'); % in meters
untracked.SpeedRadius = tmp(ind);

tmp = ncread(filename,'speed_average'); % in meters/second
untracked.SpeedAverage = tmp(ind);

tmp = ncread(filename,'latitude_max');
untracked.SSHMaxLatitude = tmp(ind);

tmp = ncread(filename,'longitude_max'); % degrees E
untracked.SSHMaxLongitude = wrapTo180(tmp(ind)); % degrees W

untracked.DaysSinceFirstDetection = NaN(height(untracked),1);

untracked.TrajectoryID = NaN(height(untracked),1);

clear tmp
clear ind

% Only Keep Eddies Whose Centers in Within Study Area
ind = inpolygon(untracked.SSHMaxLongitude,untracked.SSHMaxLatitude,bndry(1,:),bndry(2,:));

untracked = untracked(ind,:);

clear ind

% Combine Long, Short and Untracked AC Detections
eddies.AC = [eddies.AC; untracked];

clear untracked
clear dd

% Set TimeZone
eddies.AC.Date.TimeZone = 'UTC';

%% Load cyclonic mesoscale eddy atlases (i.e., long, short and untracked) from AVISO.

% Cyclonic - Long (i.e., > 10 days)
filename = 'META3.2_DT_allsat_Cyclonic_long_19930101_20220209.nc';

tmp = ncread(filename,'time');
tmp = datetime('01/01/1950') + days(tmp);

% Make dates from AVISO and shark-collected CTD same format dd-mm-yyyy.
dd.CC.Date = datetime(year(tmp),month(tmp),day(tmp));
dd.META.Date = datetime(2015,08,13):datetime(2015,09,18);
dd.META.Date = dd.META.Date.';

% Index of CC dates in metadata.
ind = ismember(dd.CC.Date,dd.META.Date);

eddies.CC = table(tmp(ind),'VariableNames',{'Date'});

clear tmp*

% Load Remaining Variables
tmp = ncread(filename,'amplitude'); % in meters
eddies.CC.Amplitude = tmp(ind);

tmp = ncread(filename,'effective_contour_latitude');
tmp = tmp(:,ind);
tmp = num2cell(tmp,1);
eddies.CC.EffectiveContourLatitude = tmp.';

tmp = ncread(filename,'effective_contour_longitude'); % degrees E
tmp = wrapTo180(tmp(:,ind)); % degrees W
tmp = num2cell(tmp,1);
eddies.CC.EffectiveContourLongitude = tmp.';

tmp = ncread(filename,'effective_radius'); % in meters
eddies.CC.EffectiveRadius = tmp(ind);

tmp = ncread(filename,'latitude');
eddies.CC.EffectiveCenterLatitude = tmp(ind);

tmp = ncread(filename,'longitude'); % degrees E
eddies.CC.EffectiveCenterLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'speed_radius'); % in meters
eddies.CC.SpeedRadius = tmp(ind);

tmp = ncread(filename,'speed_average'); % in meters/second
eddies.CC.SpeedAverage = tmp(ind);

tmp = ncread(filename,'latitude_max');
eddies.CC.SSHMaxLatitude = tmp(ind);

tmp = ncread(filename,'longitude_max'); % degrees E
eddies.CC.SSHMaxLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'observation_number');
eddies.CC.DaysSinceFirstDetection = tmp(ind);

tmp = ncread(filename,'track');
eddies.CC.TrajectoryID = tmp(ind);

clear tmp
clear ind

ind = inpolygon(eddies.CC.SSHMaxLongitude,eddies.CC.SSHMaxLatitude,bndry(1,:),bndry(2,:));

eddies.CC = eddies.CC(ind,:);

clear ind

% Cyclonic - Short (i.e., < 10 days)
filename = 'META3.2_DT_allsat_Cyclonic_short_19930101_20220209.nc';

tmp = ncread(filename,'time');
tmp = datetime('01/01/1950') + days(tmp);

% Make dates from AVISO and shark-collected CTD same format dd-mm-yyyy.
dd.CC.Date = datetime(year(tmp),month(tmp),day(tmp));

% Index of CC dates in metadata.
ind = ismember(dd.CC.Date,dd.META.Date);

short = table(tmp(ind),'VariableNames',{'Date'});

clear tmp*

% Load Remaining Variables
tmp = ncread(filename,'amplitude'); % in meters
short.Amplitude = tmp(ind);

tmp = ncread(filename,'effective_contour_latitude');
tmp = tmp(:,ind);
tmp = num2cell(tmp,1);
short.EffectiveContourLatitude = tmp.';

tmp = ncread(filename,'effective_contour_longitude'); % degrees E
tmp = wrapTo180(tmp(:,ind)); % degrees W
tmp = num2cell(tmp,1);
short.EffectiveContourLongitude = tmp.';

tmp = ncread(filename,'effective_radius'); % in meters
short.EffectiveRadius = tmp(ind);

tmp = ncread(filename,'latitude');
short.EffectiveCenterLatitude = tmp(ind);

tmp = ncread(filename,'longitude'); % degrees E
short.EffectiveCenterLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'speed_radius'); % in meters
short.SpeedRadius = tmp(ind);

tmp = ncread(filename,'speed_average'); % in meters/second
short.SpeedAverage = tmp(ind);

tmp = ncread(filename,'latitude_max');
short.SSHMaxLatitude = tmp(ind);

tmp = ncread(filename,'longitude_max'); % degrees E
short.SSHMaxLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'observation_number');
short.DaysSinceFirstDetection = tmp(ind);

tmp = ncread(filename,'track');
short.TrajectoryID = tmp(ind);

clear tmp
clear ind

% Only Keep Eddies Whose Centers in Within Study Area
ind = inpolygon(short.SSHMaxLongitude,short.SSHMaxLatitude,bndry(1,:),bndry(2,:));

short = short(ind,:);

clear ind

% Combine Long and Short CC Detections
eddies.CC = [eddies.CC; short];

clear short

% Cyclonic - Untracked
filename = 'META3.2_DT_allsat_Cyclonic_untracked_19930101_20220209.nc';

tmp = ncread(filename,'time');
tmp = datetime('01/01/1950') + days(tmp);

% Make dates from AVISO and shark-collected CTD same format dd-mm-yyyy.
dd.CC.Date = datetime(year(tmp),month(tmp),day(tmp));

% Index of CC dates in metadata.
ind = ismember(dd.CC.Date,dd.META.Date);

untracked = table(tmp(ind),'VariableNames',{'Date'});

clear tmp*

% Load Remaining Variables
tmp = ncread(filename,'amplitude'); % in meters
untracked.Amplitude = tmp(ind);

tmp = ncread(filename,'effective_contour_latitude');
tmp = tmp(:,ind);
tmp = num2cell(tmp,1);
untracked.EffectiveContourLatitude = tmp.';

tmp = ncread(filename,'effective_contour_longitude'); % degrees E
tmp = wrapTo180(tmp(:,ind)); % degrees W
tmp = num2cell(tmp,1);
untracked.EffectiveContourLongitude = tmp.';

tmp = ncread(filename,'effective_radius'); % in meters
untracked.EffectiveRadius = tmp(ind);

tmp = ncread(filename,'latitude');
untracked.EffectiveCenterLatitude = tmp(ind);

tmp = ncread(filename,'longitude'); % degrees E
untracked.EffectiveCenterLongitude = wrapTo180(tmp(ind)); % degrees W

tmp = ncread(filename,'speed_radius'); % in meters
untracked.SpeedRadius = tmp(ind);

tmp = ncread(filename,'speed_average'); % in meters/second
untracked.SpeedAverage = tmp(ind);

tmp = ncread(filename,'latitude_max');
untracked.SSHMaxLatitude = tmp(ind);

tmp = ncread(filename,'longitude_max'); % degrees E
untracked.SSHMaxLongitude = wrapTo180(tmp(ind)); % degrees W

untracked.DaysSinceFirstDetection = NaN(height(untracked),1);

untracked.TrajectoryID = NaN(height(untracked),1);

clear tmp
clear ind

% Only Keep Eddies Whose Centers in Within Study Area
ind = inpolygon(untracked.SSHMaxLongitude,untracked.SSHMaxLatitude,bndry(1,:),bndry(2,:));

untracked = untracked(ind,:);

clear ind

% Combine Long, Short and Untracked CC Detections
eddies.CC = [eddies.CC; untracked];

clear untracked
clear dd

% Set TimeZone
eddies.CC.Date.TimeZone = 'UTC';

clear bndry
clear filename