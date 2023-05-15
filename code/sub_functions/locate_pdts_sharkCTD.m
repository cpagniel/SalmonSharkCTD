%% locate_pdts_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; linearly interpolate positions from SPOT tags
% to every 1 hr and estimate location of PDTs by taking mean over summary period.

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

    %% Interpolate SPOT longitude and latitude to every hour and take mean .

    for j = 1:max(pdt.GlobalNumber)-1

        if toppID.spot(i) == unique(pdt.toppID(pdt.GlobalNumber == j))

            if pdt.PDTNumber(pdt.GlobalNumber == j) == 1
                tmp.DateTime = datenum(unique(pdt.DateTime(pdt.GlobalNumber == j)):hours(1):unique(pdt.DateTime(pdt.GlobalNumber == j+1)));
                tmp.Longitude = interp1(datenum(SPOT.date),SPOT.lon,tmp.DateTime).';
                tmp.Latitude = interp1(datenum(SPOT.date),SPOT.lat,tmp.DateTime).';

                pdt.MeanLongitude(pdt.GlobalNumber == j) = mean(tmp.Longitude,'omitnan');
                pdt.RangeLongitude(pdt.GlobalNumber == j) = max(tmp.Longitude)-min(tmp.Longitude);
                pdt.MeanLatitude(pdt.GlobalNumber == j) = mean(tmp.Latitude,'omitnan');
                pdt.RangeLatitude(pdt.GlobalNumber == j) = max(tmp.Latitude)-min(tmp.Latitude);
            else
                tmp.summary = meta.summary_hours(toppID.spot(i) == meta.toppid);
                tmp.DateTime = datenum(unique(pdt.DateTime(pdt.GlobalNumber == j)):hours(1):unique(pdt.DateTime(pdt.GlobalNumber == j))+hours(tmp.summary));
                tmp.Longitude = interp1(datenum(SPOT.date),SPOT.lon,tmp.DateTime).';
                tmp.Latitude = interp1(datenum(SPOT.date),SPOT.lat,tmp.DateTime).';

                pdt.MeanLongitude(pdt.GlobalNumber == j) = mean(tmp.Longitude,'omitnan');
                pdt.RangeLongitude(pdt.GlobalNumber == j) = max(tmp.Longitude)-min(tmp.Longitude);
                pdt.MeanLatitude(pdt.GlobalNumber == j) = mean(tmp.Latitude,'omitnan');
                pdt.RangeLatitude(pdt.GlobalNumber == j) = max(tmp.Latitude)-min(tmp.Latitude);
            end

        end
        clear tmp

    end
    clear j
    clear SPOT

end
clear i
clear files

clear meta

%% Only keep PDTs collected between 50 to 60 deg N and 150 to 125 deg W.

[~,ind,~] = unique(pdt.GlobalNumber);
tmp.gnumb = pdt.GlobalNumber(ind);
tmp.lat = pdt.MeanLatitude(ind);
tmp.lon = pdt.MeanLongitude(ind);

ind_lat = tmp.lat >= 50 & tmp.lat <= 60;
ind_lon = tmp.lon >= -150 & tmp.lon <= -125;
ind = ind_lat + ind_lon == 2;

pdt(ismember(pdt.GlobalNumber,tmp.gnumb(ind)) == 0,:) = [];

clear ind*
clear tmp

%% Re Assign global PDT number.

old_tag = pdt.toppID(1);
old_pdt = pdt.PDTNumber(1);

pdt.GlobalNumber(1) = 1;

cnt = 1;
for i = 2:height(pdt)
    if pdt.toppID(i) == old_tag && pdt.PDTNumber(i) == old_pdt
        pdt.GlobalNumber(i) = cnt;
    else
        cnt = cnt + 1;
        pdt.GlobalNumber(i) = cnt;

        old_tag = pdt.toppID(i);
        old_pdt = pdt.PDTNumber(i);
    end
end
clear i
clear cnt

clear old*

%% Add locations and dates to pfl variable.

[~,ind,~] = unique(pdt.GlobalNumber,'last');
pfl.PDT.Latitude = pdt.MeanLatitude(ind);
pfl.PDT.Longitude = pdt.MeanLongitude(ind);
pfl.PDT.DateTime = pdt.DateTime(ind);
pfl.PDT.DateTime.TimeZone = 'UTC';
pfl.PDT.toppID = pdt.toppID(ind);
pfl.PDT.MaxDepth = pdt.Depth(ind);

clear ind