%% load_CTDSRDL_sharkCTD.m
% Sub-function SalmonSharksCTD.m; loads CTD-SRDL data from shark fin tag.

%% Location of data.

cd([folder '/data/ctd/1715013_13219/odv']);
load('data_from_1715013_13219_ODV.mat');

%% Load data.

shark.raw.p = pressure_dbar; % dBar
shark.raw.S = salinity_PSU; % PSU
shark.raw.T = temperature_C; % degrees C

shark.raw.lat = latitude_degN; % degrees North
shark.raw.lon = longitude_degE; % degrees Easth
shark.raw.lon = wrapTo180(shark.raw.lon); % degrees W

shark.raw.time = date_time_days_since_20150101_000000UTC; % Julian Days in 2015
shark.raw.datenum = datenum(2015,0,shark.raw.time);
shark.raw.datetime = datetime(shark.raw.datenum,'ConvertFrom','datenum') + day(1);
shark.raw.datenum = datenum(shark.raw.datetime);
shark.raw.datetime.TimeZone = 'UTC';
shark.raw.datetime.TimeZone = 'America/Los_Angeles';

%% Set tagging location.

shark.raw.tagdeploy.lon = -146.0544;
shark.raw.tagdeploy.lat = 60.76855;

%% Plot raw in situ temperature and practical salinity data vs. pressure.

figure;

for i = 1:length(shark.raw.datenum)
    dt = day(shark.raw.datetime(i) - shark.raw.datetime(1)) + 1;

    subplot(1,2,1)
    plot(shark.raw.T(:,i),shark.raw.p(:,i),'-','Color',cmap(dt,:));
    set(gca,'ydir','reverse','FontSize',18);
    xlabel('{\it in situ} Temperature (^oC)','FontSize',20); ylabel('Pressure (dbar)','FontSize',20);
    hold on

    subplot(1,2,2)
    plot(shark.raw.S(:,i),shark.raw.p(:,i),'-','Color',cmap(dt,:));
    set(gca,'ydir','reverse','FontSize',18);
    xlabel('Practical Salinity (PSU)','FontSize',20); % ylabel('Pressure (dbar)','FontSize',20);
    hold on
 
end
clear i

%% Save.

cd([folder '/figures'])
saveas(gcf,'CTD_profiles_raw.fig');
exportgraphics(gcf,'CTD_profiles_raw.png','Resolution',300);

close all

%% Clear.

clearvars -except shark cmap folder