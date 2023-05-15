%% load_SPOT_interpPFL_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load SPOT tracks & linearly interpolate 
% positions from SPOT tags every 17.2 hours to estimate potential 
% number of profiles.

%% Load re-routed (i.e., points on land are moved into the water), random walk tracks from aniMotum from SPOT tags.

cd([folder '/data/spot']);
files = dir('*_rw_rerouting.csv');

for i = 1:length(files)

    toppID.spot(i) = str2double(files(i).name(1:7));

    SPOT = readtable(files(i).name);
    SPOT.date.TimeZone = 'UTC';

    %% Correct tracks for errors.

    % 1. Some SPOT tags have erroneous start and end locations. These
    % corrections are hard-coded.

    % 2. Most have siginificant portions where the track is simply a straight
    % line and subsequent positions are separated by an equavalent distance.
    % Remove all of these instances.

    % Hard coded for specific tracks.
    if toppID.spot(i) == 1705007
        SPOT(1:2,:) = []; SPOT(end,:) = []; % remove first, second and end location
    elseif toppID.spot(i) == 1706018
        SPOT(1:4,:) = []; SPOT(end,:) = []; % remove first four locations and end location
    elseif toppID.spot(i) == 1710023
        SPOT.lon(find(SPOT.lon > 0)) = SPOT.lon(find(SPOT.lon > 0))*-1; % longitude are supposed to be negative
    else
        SPOT(end,:) = []; % remove end location
    end

    ind = find(abs(roundn(diff(m_lldist(SPOT.lon,SPOT.lat)),-1)) <= 0.1);
    if ~isempty(ind)
        if ind(end) == height(SPOT)-2
            ind = [ind+1; height(SPOT)];
        end

        SPOT(ind,:) = [];
    end
    clear ind

    %% Interpolate SPOT longitude and latitude to estimate position every 17.2 hours.

    tmp.SPOT(i).DateTime = SPOT.date(1):hours(17.2):SPOT.date(end);

    tmp.SPOT(i).Longitude = interp1(datenum(SPOT.date),SPOT.lon,datenum(tmp.SPOT(i).DateTime));
    tmp.SPOT(i).Latitude = interp1(datenum(SPOT.date),SPOT.lat,datenum(tmp.SPOT(i).DateTime));

    tmp.SPOT(i).toppID = ones(1,length(tmp.SPOT(i).Latitude)).*toppID.spot(i);

    clear SPOT

end
clear i
clear files

%% Linearize variables.

pfl.SPOT.Latitude = [tmp.SPOT.Latitude];
pfl.SPOT.Longitude = [tmp.SPOT.Longitude];
pfl.SPOT.DateTime = [tmp.SPOT.DateTime];
pfl.SPOT.toppID = [tmp.SPOT.toppID];

clear tmp

%% Only keep potential shark-collected profiles from 50 to 60 deg N and 150 to 125 deg W.

ind_lat = pfl.SPOT.Latitude >= 50 & pfl.SPOT.Latitude <= 60;
ind_lon = pfl.SPOT.Longitude >= -150 & pfl.SPOT.Longitude <= -125;

ind = ind_lat + ind_lon == 2;

pfl.SPOT.Longitude = pfl.SPOT.Longitude(ind);
pfl.SPOT.Latitude = pfl.SPOT.Latitude(ind);
pfl.SPOT.DateTime = pfl.SPOT.DateTime(ind);
pfl.SPOT.toppID = pfl.SPOT.toppID(ind);

clear ind*