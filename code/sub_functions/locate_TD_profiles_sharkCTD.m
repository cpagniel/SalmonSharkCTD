%% locate_TD_profiles_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; linearly interpolate positions from SPOT tags
% to estimate location of temperature-depth profiles.

%% Load re-routed (i.e., points on land are moved into the water), random walk tracks from aniMotum from SPOT tags.

cd([folder '/data/spot']);
files = dir('*_rw_rerouting.csv');

for i = 1:length(files)
    toppID.spot(i) = str2double(files(i).name(1:7));

    if sum(str2double(files(i).name(1:7)) == toppID.pat) == 1

        SPOT = readtable(files(i).name);
        SPOT.date.TimeZone = 'UTC';

        %% Correct tracks for errors.

        % 1. Some SPOT tags have erroneous start and end locations. These
        % corrections are hard-coded.

        % 2. Most have siginificant portions where the track is simply a straight
        % line and subsequent positions are separated by an equavalent distance.
        % Remove all of these instances if the track is at least 25 points.

        if height(SPOT) > 25

            % Hard coded for specific tracks.
            if toppID.spot(i) == 1702003
                SPOT(1,:) = []; SPOT(end,:) = []; % remove first and end location
            elseif toppID.spot(i) == 1705007
                SPOT(1:2,:) = []; SPOT(end,:) = []; % remove first, second and end location
            else
                SPOT(end,:) = []; % remove end location
            end

            ind = find(abs(roundn(diff(m_lldist(SPOT.lon,SPOT.lat)),-1)) <= 0.1);
            if ind(end) == height(SPOT)-2
                ind = [ind+1; height(SPOT)];
            end
            SPOT(ind,:) = [];
            clear ind

        end

        %% Interpolate SPOT longitude and latitude based on time of each profile.

        ind = find(str2double(files(i).name(1:7)) == toppID.pat);

        pfl.PAT(ind).Longitude = interp1(datenum(SPOT.date),SPOT.lon,datenum(pfl.PAT(ind).start_time)).';
        pfl.PAT(ind).Latitude = interp1(datenum(SPOT.date),SPOT.lat,datenum(pfl.PAT(ind).start_time)).';

        clear ind
        clear SPOT

    end
end
clear i

%% Clear

clear files