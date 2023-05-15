%% plot_histo_allPFLs_month_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot histograms of number of profiles
% of each type of platform by month in the Gulf of Alaska.

%% Bin profiles of each platform by month.

% Recovered PAT profiles
tmp.PAT.lat = [pfl.PAT.Latitude].'; tmp.PAT.lon = [pfl.PAT.Longitude].';
tmp.PAT.date = vertcat(pfl.PAT.start_time);
tmp.PAT.depth = vertcat(pfl.PAT.DepthRange); 

ind = tmp.PAT.depth >= 24;
tmp.PAT.lat(~ind) = []; tmp.PAT.lon(~ind) = []; 
tmp.PAT.date(~ind) = [];
tmp.PAT.depth(~ind) = [];
clear ind

ind_lon = tmp.PAT.lon <= -125 & tmp.PAT.lon >= -150; ind_lat = tmp.PAT.lat >= 50 & tmp.PAT.lat <= 60;
ind = ind_lon + ind_lat == 2;

binned.month.sharkPAT = histcounts(month(tmp.PAT.date(ind)),1:1:12+1);

clear ind*
clear tmp

% PDTs
binned.month.sharkPDT = histcounts(month(pfl.PDT.DateTime),1:1:12+1);

% Recovered PAT + PDTs
binned.month.sharkPAT_PDT = histcounts(month(pfl.PAT_PDT.DateTime),1:1:12+1);

% Interpolated profiles from SPOT tags
binned.month.sharkCTD = histcounts(month(pfl.SPOT.DateTime),1:1:12+1);

% WOD
binned.month.APB = histcounts(month(wod.SPOT.APB.date),1:1:12+1);
binned.month.CTD = histcounts(month(wod.SPOT.CTD.date),1:1:12+1);
binned.month.GLD = histcounts(month(wod.SPOT.GLD.date),1:1:12+1);
binned.month.OSD = histcounts(month(wod.SPOT.OSD.date),1:1:12+1);
binned.month.PFL = histcounts(month(wod.SPOT.PFL.date),1:1:12+1);
binned.month.all = binned.month.APB + binned.month.CTD + binned.month.GLD + binned.month.OSD + binned.month.PFL;

%% Number of unique TOPPids per month from SPOT.

mm = unique(month(pfl.SPOT.DateTime));
mm = mm(1):1:mm(end);
cnt_SPOT = zeros(length(mm),1);
for i = 1:length(mm)
    cnt_SPOT(i) = length(unique(pfl.SPOT.toppID(month(pfl.SPOT.DateTime) == mm(i))));
end
clear i

%% Number of unique TOPPids per month from SPOT+PAT.

cnt_PDT = zeros(length(mm),1);
for i = 1:length(mm)
    cnt_PDT(i) = length(unique(pfl.PDT.toppID(month(pfl.PDT.DateTime) == mm(i))));
end
clear i

for i = 1:length(pfl.PAT)
    tmp = unique(month(pfl.PAT(i).start_time));
    cnt_PDT(tmp) = cnt_PDT(tmp)+1;
end
clear i

clear mm
clear tmp

%% Colormap

tmp = cmocean('balance',16);
cmap = tmp(5,:);

tmp = cmocean('curl',16);
cmap = [cmap; tmp(5,:)];

tmp = cmocean('balance',16);
cmap = [cmap; tmp(end-5,:)];

clear tmp

%% Number of PDTs as well as potential profiles by SPOT-tagged sharks and total in WOD.

figure('Position',[720 115 1136 420]);

bar(1:1:12,[binned.month.sharkPAT_PDT; binned.month.sharkCTD; binned.month.all].','hist');

set(gca,'FontSize',20);
xlabel('Month','FontSize',24); 
ylabel('Number of Profiles','FontSize',24);

hold on

colororder({'k','k'})
yyaxis right

% number of tagged sharks per month
plot(1:1:12,cnt_SPOT,'o--','LineWidth',2);

hold on

plot(1:1:12,cnt_PDT,'*-','LineWidth',2);
ylabel('Number of Tagged Sharks','FontSize',24);

legend('PAT','CTD-SRDL','WOD','SPOT','SPOT+PAT','NumColumns',2,'Location','northwest');

xlim([0 13]);
colormap(cmap);

%% Save.

cd([folder '/figures']);
saveas(gcf,'histo_pfl_cnt_month.fig');
exportgraphics(gcf,'hist_pfl_cnt_month.png','Resolution',300)

close all

%% Number of PDTs as well as potential profiles by SPOT-tagged sharks and in WOD by platform.

figure('Position',[720 115 1136 420]);

bar(1:1:12,[binned.month.sharkPDT; binned.month.sharkPAT; binned.month.sharkCTD; ...
    binned.month.APB; binned.month.CTD; binned.month.GLD; binned.month.OSD; ...
    binned.month.PFL].','hist');

set(gca,'FontSize',20);
xlabel('Month','FontSize',24); 
ylabel('Number of Profiles','FontSize',24);
ylim([0 3500]);

hold on

colororder({'k','k'})
yyaxis right

% number of tagged sharks per year
plot(1:1:12,cnt_SPOT,'o--','LineWidth',2);

hold on

plot(1:1:12,cnt_PDT,'*-','LineWidth',2);
ylabel('Number of Tagged Sharks','FontSize',24);

legend('PDT','PAT','CTD-SRDL','APB','CTD','GLD','OSD','PFL','SPOT','SPOT+PAT','NumColumns',3,'Location','northwest');

xlim([0 13]);
colormap([cmap; [253,180,98]./256; [255,255,179]./256;...
    [188,128,189]./256; [252,205,229]./256; [217,217,217]./256]);

%% Save

cd([folder '/figures']);
saveas(gcf,'histo_pfl_cnt_month_by_platform.fig');
exportgraphics(gcf,'hist_pfl_cnt_month_by_platform.png','Resolution',300)

close all

%% Clear

clear cnt*
clear cmap