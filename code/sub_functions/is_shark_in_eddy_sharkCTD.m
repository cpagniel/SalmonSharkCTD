%% is_shark_in_eddy_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; determines whether location of
% shark-collected CTD profiles and ARGOS positions from CTD-SRDL tag are
% within an eddy.

%% Determine whether the shark-collected CTD was within an eddy.

for i = 1:length(shark.corr.datetime)

    if ~isnat(shark.corr.datetime(i))

        %% Get eddies that occur on days with shark CTDs.

        tmp.date.ind_AC = ismember(eddies.AC.Date,datetime(year(shark.corr.datetime(i)),month(shark.corr.datetime(i)),day(shark.corr.datetime(i)),'TimeZone','UTC'));
        tmp.date.ind_CC = ismember(eddies.CC.Date,datetime(year(shark.corr.datetime(i)),month(shark.corr.datetime(i)),day(shark.corr.datetime(i)),'TimeZone','UTC'));

        tmp.eddies = [eddies.AC(tmp.date.ind_AC,:); eddies.CC(tmp.date.ind_CC,:)];

        tmp.ind_eddy = [ones(sum(tmp.date.ind_AC),1); zeros(sum(tmp.date.ind_CC),1)]; % 1 = AC, 0 = CC

        tmp.contours.lon = cell2mat(table2array(tmp.eddies(:,"EffectiveContourLongitude")).').';
        tmp.contours.lat = cell2mat(table2array(tmp.eddies(:,"EffectiveContourLatitude")).').';

        tmp.contours.lon(:,end+1) = tmp.contours.lon(:,1);
        tmp.contours.lat(:,end+1) = tmp.contours.lat(:,1);

        %% Is shark-collected CTD profile collected in an eddy?

        for j = 1:length(tmp.ind_eddy)
            [in,on] = inpolygon(shark.corr.lon(i),shark.corr.lat(i),tmp.contours.lon(j,:),tmp.contours.lat(j,:));
            tmp.ind_shark(j,1) = sum(in + on, 2) >= 1;
        end
        clear j
        clear in on

        %% Assign eddy type to shark and eddy properties.

        if sum(tmp.ind_shark) == 0
            shark.eddy.type(i) = NaN;
            shark.eddy.amplitude(i) = NaN;
            shark.eddy.speed_radius(i) = NaN;
            shark.eddy.avg_speed(i) = NaN;
            shark.eddy.center(i,:) = [NaN,NaN];
            shark.eddy.lifetime(i) = NaN;
        else
            shark.eddy.type(i) = tmp.ind_eddy(tmp.ind_shark);
            shark.eddy.amplitude(i) = table2array(tmp.eddies(tmp.ind_shark,'Amplitude'));
            shark.eddy.speed_radius(i) = table2array(tmp.eddies(tmp.ind_shark,'SpeedRadius'));
            shark.eddy.avg_speed(i) = table2array(tmp.eddies(tmp.ind_shark,'SpeedAverage'));
            shark.eddy.center(i,:) = [table2array(tmp.eddies(tmp.ind_shark,'SSHMaxLongitude')),...
                table2array(tmp.eddies(tmp.ind_shark,'SSHMaxLatitude'))];
            shark.eddy.lifetime(i) = table2array(tmp.eddies(tmp.ind_shark,'DaysSinceFirstDetection'));
        end

    else
        shark.eddy.type(i) = NaN;
        shark.eddy.amplitude(i) = NaN;
        shark.eddy.speed_radius(i) = NaN;
        shark.eddy.avg_speed(i) = NaN;
        shark.eddy.center(i,:) = [NaN,NaN];
        shark.eddy.lifetime(i) = NaN;
    end
    clear tmp
end
clear i

%% Determine if ARGOS position from CTD-SRDL tag is in an eddy.

argos.date.TimeZone = 'UTC';

for i = 36:length(argos.date)-14 % there are argos positions from earlier dates that we are not including in the analyses

    if ~isnat(argos.date(i))

        %% Get eddies that occur on days with ARGOS position from CTD-SRDL tag.

        tmp.date.ind_AC = ismember(eddies.AC.Date,datetime(year(argos.date(i)),month(argos.date(i)),day(argos.date(i)),'TimeZone','UTC'));
        tmp.date.ind_CC = ismember(eddies.CC.Date,datetime(year(argos.date(i)),month(argos.date(i)),day(argos.date(i)),'TimeZone','UTC'));

        tmp.eddies = [eddies.AC(tmp.date.ind_AC,:); eddies.CC(tmp.date.ind_CC,:)];

        tmp.ind_eddy = [ones(sum(tmp.date.ind_AC),1); zeros(sum(tmp.date.ind_CC),1)]; % 1 = AC, 0 = CC

        tmp.contours.lon = cell2mat(table2array(tmp.eddies(:,"EffectiveContourLongitude")).').';
        tmp.contours.lat = cell2mat(table2array(tmp.eddies(:,"EffectiveContourLatitude")).').';

        tmp.contours.lon(:,end+1) = tmp.contours.lon(:,1);
        tmp.contours.lat(:,end+1) = tmp.contours.lat(:,1);

        %% Is shark ARGOS position in an eddy?

        for j = 1:length(tmp.ind_eddy)
            [in,on] = inpolygon(argos.lon(i),argos.lat(i),tmp.contours.lon(j,:),tmp.contours.lat(j,:));
            tmp.ind_shark(j,1) = sum(in + on, 2) >= 1;
        end
        clear j
        clear in on

        %% Assign eddy type to shark and eddy properties.

        if sum(tmp.ind_shark) == 0
            argos.eddy.type(i) = NaN;
            argos.eddy.amplitude(i) = NaN;
            argos.eddy.speed_radius(i) = NaN;
            argos.eddy.avg_speed(i) = NaN;
            argos.eddy.center(i,:) = [NaN,NaN];
            argos.eddy.lifetime(i) = NaN;
        else
            argos.eddy.type(i) = tmp.ind_eddy(tmp.ind_shark);
            argos.eddy.amplitude(i) = table2array(tmp.eddies(tmp.ind_shark,'Amplitude'));
            argos.eddy.speed_radius(i) = table2array(tmp.eddies(tmp.ind_shark,'SpeedRadius'));
            argos.eddy.avg_speed(i) = table2array(tmp.eddies(tmp.ind_shark,'SpeedAverage'));
            argos.eddy.center(i,:) = [table2array(tmp.eddies(tmp.ind_shark,'SSHMaxLongitude')),...
                table2array(tmp.eddies(tmp.ind_shark,'SSHMaxLatitude'))];
            argos.eddy.lifetime(i) = table2array(tmp.eddies(tmp.ind_shark,'DaysSinceFirstDetection'));
        end

    else
        argos.eddy.type(i) = NaN;
        argos.eddy.amplitude(i) = NaN;
        argos.eddy.speed_radius(i) = NaN;
        argos.eddy.avg_speed(i) = NaN;
        argos.eddy.center(i,:) = [NaN,NaN];
        argos.eddy.lifetime(i) = NaN;
    end
    clear tmp
end
clear i

%% Blank early ARGOS positions before CTD casts begin.

argos.eddy.type(1:35) = NaN;
argos.eddy.amplitude(1:35) = NaN;
argos.eddy.speed_radius(1:35) = NaN;
argos.eddy.avg_speed(1:35) = NaN;
argos.eddy.center(1:35,1:2) = NaN;
argos.eddy.lifetime(1:35) = NaN;

argos.eddy.type = [argos.eddy.type NaN(1,14)];
argos.eddy.amplitude = [argos.eddy.amplitude NaN(1,14)];
argos.eddy.speed_radius = [argos.eddy.speed_radius NaN(1,14)];
argos.eddy.avg_speed = [argos.eddy.avg_speed NaN(1,14)];
argos.eddy.center = [argos.eddy.center; NaN(14,2)];
argos.eddy.lifetime = [argos.eddy.lifetime NaN(1,14)];