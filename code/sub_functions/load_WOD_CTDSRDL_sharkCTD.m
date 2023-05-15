%% load_WOD_CTDSRDL_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load World Ocean Database data during 
% CTD-SRDL deployment.

% Requires gsw MATLAB toolbox (http://www.teos-10.org/software.htm).

%% Load CTD casts from the World Ocean Database.

cd([folder '/data/wod/during_CTD_tag/CTD']);
filelist = dir('wod*');

for i = 1:length(filelist)
    wod.CTDSRDL.CTD.lat(i,:) = ncread(filelist(i).name,'lat'); % deg N
    wod.CTDSRDL.CTD.lon(i,:) = ncread(filelist(i).name,'lon'); % deg E

    wod.CTDSRDL.CTD.date(i,:) = ncread(filelist(i).name,'date'); % YYYYMMDD
    wod.CTDSRDL.CTD.GMT_time(i,:) = ncread(filelist(i).name,'GMT_time');

    wod.CTDSRDL.CTD.T{i} = ncread(filelist(i).name,'Temperature'); % deg C, in-situ
    wod.CTDSRDL.CTD.S{i} = ncread(filelist(i).name,'Salinity'); % PSU, practical
    wod.CTDSRDL.CTD.p{i} = ncread(filelist(i).name,'Pressure'); % dbar
end
clear i
clear filelist

wod.CTDSRDL.CTD.date = datetime(wod.CTDSRDL.CTD.date,'ConvertFrom','yyyymmdd');
[H,M,S] = hms(hours(wod.CTDSRDL.CTD.GMT_time));
wod.CTDSRDL.CTD.HMS = [H M S];

tmp = datetime(year(wod.CTDSRDL.CTD.date),month(wod.CTDSRDL.CTD.date),day(wod.CTDSRDL.CTD.date),H,M,S,'TimeZone','UTC');
tmp.TimeZone = 'America/Los_Angeles';
wod.CTDSRDL.CTD.time = tmp;

clear H M S tmp

%% Remove outliers (i.e., values less than 0) from salinity.

for i = 1:length(wod.CTDSRDL.CTD.S)
    tmp = wod.CTDSRDL.CTD.S{i};
    tmp(tmp <= 0) = NaN;
    wod.CTDSRDL.CTD.S{i} = tmp;
end
clear i

clear tmp

%% Convert in situ temperature and practical salinity to conservative temperature and absolute salinity.
% Convert pressure (dbar) to depth (m).

wod.CTDSRDL.CTD.SA = NaN(2003,length(wod.CTDSRDL.CTD.S)); % Note, 2003 is the longest profile length.
wod.CTDSRDL.CTD.CT = NaN(2003,length(wod.CTDSRDL.CTD.S));
wod.CTDSRDL.CTD.z = NaN(2003,length(wod.CTDSRDL.CTD.S)); 

for i = 1:length(wod.CTDSRDL.CTD.S)
    wod.CTDSRDL.CTD.SA(1:length(wod.CTDSRDL.CTD.S{i}),i) = gsw_SA_from_SP(wod.CTDSRDL.CTD.S{i},wod.CTDSRDL.CTD.p{i},wod.CTDSRDL.CTD.lon(i),wod.CTDSRDL.CTD.lat(i));
    wod.CTDSRDL.CTD.CT(1:length(wod.CTDSRDL.CTD.T{i}),i) = gsw_CT_from_t(wod.CTDSRDL.CTD.SA(1:length(wod.CTDSRDL.CTD.S{i}),i),wod.CTDSRDL.CTD.T{i},wod.CTDSRDL.CTD.p{i});
    wod.CTDSRDL.CTD.z(1:length(wod.CTDSRDL.CTD.p{i}),i) = gsw_z_from_p(wod.CTDSRDL.CTD.p{i},wod.CTDSRDL.CTD.lat(i))*-1;
end
clear i

%% Load Argo casts from the World Ocean Database.

cd([folder '/data/wod/during_CTD_tag/PFL']);
filelist = dir('wod*');

cnt = 1;
for i = 1:length(filelist)
    tmp.date = ncread(filelist(i).name,'date'); % YYYYMMDD
    tmp.date = datetime(tmp.date,'ConvertFrom','yyyymmdd');

    tmp.time = ncread(filelist(i).name,'GMT_time');
    [tmp.H,tmp.M,tmp.S] = hms(hours(tmp.time));

    tmp.datetime = datetime(year(tmp.date),month(tmp.date),day(tmp.date),tmp.H,tmp.M,tmp.S,'TimeZone','UTC');
    tmp.datetime.TimeZone = 'America/Los_Angeles';

    if tmp.datetime < shark.corr.datetime(1) || tmp.datetime > shark.corr.datetime(end)
        continue
    else
        wod.CTDSRDL.PFL.lat(cnt,:) = ncread(filelist(i).name,'lat'); % deg N
        wod.CTDSRDL.PFL.lon(cnt,:) = ncread(filelist(i).name,'lon'); % deg E

        wod.CTDSRDL.PFL.date(cnt,:) = ncread(filelist(i).name,'date'); % YYYYMMDD
        wod.CTDSRDL.PFL.GMT_time(cnt,:) = ncread(filelist(i).name,'GMT_time');

        wod.CTDSRDL.PFL.T{cnt} = ncread(filelist(i).name,'Temperature'); % deg C, in-situ
        wod.CTDSRDL.PFL.S{cnt} = ncread(filelist(i).name,'Salinity'); % PSU, practical
        wod.CTDSRDL.PFL.p{cnt} = ncread(filelist(i).name,'Pressure'); % dbar

        cnt = cnt + 1;
    end
    clear tmp
end
clear i
clear cnt
clear filelist

wod.CTDSRDL.PFL.date = datetime(wod.CTDSRDL.PFL.date,'ConvertFrom','yyyymmdd');
[H,M,S] = hms(hours(wod.CTDSRDL.PFL.GMT_time));
wod.CTDSRDL.PFL.HMS = [H M S];

tmp = datetime(year(wod.CTDSRDL.PFL.date),month(wod.CTDSRDL.PFL.date),day(wod.CTDSRDL.PFL.date),H,M,S,'TimeZone','UTC');
tmp.TimeZone = 'America/Los_Angeles';
wod.CTDSRDL.PFL.time = tmp;

clear H M S tmp

%% Remove outliers (i.e., values less than 0) from salinity.

for i = 1:length(wod.CTDSRDL.PFL.S)
    tmp = wod.CTDSRDL.PFL.S{i};
    tmp(tmp <= 0) = NaN;
    wod.CTDSRDL.PFL.S{i} = tmp;
end
clear i

clear tmp

%% Convert _in situ_ temperature and practical salinity to conservative temperature and absolute salinity.
% Convert pressure (dbar) to depth (m).

wod.CTDSRDL.PFL.SA = NaN(1003,length(wod.CTDSRDL.PFL.S)); % Note, 1003 is the longest profile length.
wod.CTDSRDL.PFL.CT = NaN(1003,length(wod.CTDSRDL.PFL.S));
wod.CTDSRDL.PFL.P = NaN(1003,length(wod.CTDSRDL.PFL.S));
wod.CTDSRDL.PFL.z = NaN(1003,length(wod.CTDSRDL.PFL.S));

for i = 1:length(wod.CTDSRDL.PFL.S)
    wod.CTDSRDL.PFL.SA(1:length(wod.CTDSRDL.PFL.S{i}),i) = gsw_SA_from_SP(wod.CTDSRDL.PFL.S{i},wod.CTDSRDL.PFL.p{i},wod.CTDSRDL.PFL.lon(i),wod.CTDSRDL.PFL.lat(i));
    wod.CTDSRDL.PFL.CT(1:length(wod.CTDSRDL.PFL.T{i}),i) = gsw_CT_from_t(wod.CTDSRDL.PFL.SA(1:length(wod.CTDSRDL.PFL.S{i}),i),wod.CTDSRDL.PFL.T{i},wod.CTDSRDL.PFL.p{i});
    wod.CTDSRDL.PFL.P(1:length(wod.CTDSRDL.PFL.p{i}),i) = wod.CTDSRDL.PFL.p{i};
    wod.CTDSRDL.PFL.z(1:length(wod.CTDSRDL.PFL.p{i}),i) = gsw_z_from_p(wod.CTDSRDL.PFL.p{i},wod.CTDSRDL.PFL.lat(i))*-1;
end
clear i