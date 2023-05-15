%% load_WOD_2002_to_2019_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load WOD profiles on dates of
% potential shark-collected profiles from SPOT tags.

%% Load WOD profiles between 2002 and 2019 within the Gulf of Alaska.
% Previous combined into a .mat file based on platform.

load([folder '/data/wod/over_all_tags/WOD_all_tags_by_type.mat'])

wod.SPOT.APB = APB;
wod.SPOT.CTD = CTD;
wod.SPOT.GLD = GLD;
wod.SPOT.OSD = OSD;
wod.SPOT.PFL = PFL;

clear APB
clear CTD
clear GLD
clear OSD
clear PFL

%% Only keep WOD profiles that are on dates of shark-collected profiles.

tmp = datetime(year(pfl.SPOT.DateTime),month(pfl.SPOT.DateTime),day(pfl.SPOT.DateTime));

wod.SPOT.APB.date = datetime(year(wod.SPOT.APB.time),month(wod.SPOT.APB.time),day(wod.SPOT.APB.time));
ind = ismember(wod.SPOT.APB.date,tmp);
wod.SPOT.APB.lat(ind == 0,:) = []; wod.SPOT.APB.lon(ind == 0,:) = []; wod.SPOT.APB.time(ind == 0,:) = []; wod.SPOT.APB.date(ind == 0,:) = [];
wod.SPOT.APB.n = length(wod.SPOT.APB.lat);

wod.SPOT.CTD.date = datetime(year(wod.SPOT.CTD.time),month(wod.SPOT.CTD.time),day(wod.SPOT.CTD.time));
ind = ismember(wod.SPOT.CTD.date,tmp);
wod.SPOT.CTD.lat(ind == 0,:) = []; wod.SPOT.CTD.lon(ind == 0,:) = []; wod.SPOT.CTD.time(ind == 0,:) = []; wod.SPOT.CTD.date(ind == 0,:) = [];
wod.SPOT.CTD.n = length(wod.SPOT.CTD.lat);

wod.SPOT.GLD.date = datetime(year(wod.SPOT.GLD.time),month(wod.SPOT.GLD.time),day(wod.SPOT.GLD.time));
ind = ismember(wod.SPOT.GLD.date,tmp);
wod.SPOT.GLD.lat(ind == 0,:) = []; wod.SPOT.GLD.lon(ind == 0,:) = []; wod.SPOT.GLD.time(ind == 0,:) = []; wod.SPOT.GLD.date(ind == 0,:) = [];
wod.SPOT.GLD.n = length(wod.SPOT.GLD.lat);

wod.SPOT.OSD.date = datetime(year(wod.SPOT.OSD.time),month(wod.SPOT.OSD.time),day(wod.SPOT.OSD.time));
ind = ismember(wod.SPOT.OSD.date,tmp);
wod.SPOT.OSD.lat(ind == 0,:) = []; wod.SPOT.OSD.lon(ind == 0,:) = []; wod.SPOT.OSD.time(ind == 0,:) = []; wod.SPOT.OSD.date(ind == 0,:) = [];
wod.SPOT.OSD.n = length(wod.SPOT.OSD.lat);

wod.SPOT.PFL.date = datetime(year(wod.SPOT.PFL.time),month(wod.SPOT.PFL.time),day(wod.SPOT.PFL.time));
ind = ismember(wod.SPOT.PFL.date,tmp);
wod.SPOT.PFL.lat(ind == 0,:) = []; wod.SPOT.PFL.lon(ind == 0,:) = []; wod.SPOT.PFL.time(ind == 0,:) = []; wod.SPOT.PFL.date(ind == 0,:) = [];
wod.SPOT.PFL.n = length(wod.SPOT.PFL.lat);

%% Clear

clear tmp
clear ind