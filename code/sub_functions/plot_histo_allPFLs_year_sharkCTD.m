%% plot_histo_allPFLs_year_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot histograms of number of profiles
% of each type of platform by year in the Gulf of Alaska.

%% Bin profiles of each platform by year.

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

binned.year.sharkPAT = histcounts(year(tmp.PAT.date(ind)),2002:1:2019+1);

clear ind*
clear tmp

% PDTs
binned.year.sharkPDT = histcounts(year(pfl.PDT.DateTime),2002:1:2019+1);

% Recovered PAT + PDTs
binned.year.sharkPAT_PDT = histcounts(year(pfl.PAT_PDT.DateTime),2002:1:2019+1);

% Interpolated profiles from SPOT tags
binned.year.sharkCTD = histcounts(year(pfl.SPOT.DateTime),2002:1:2019+1);

% WOD
binned.year.APB = histcounts(year(wod.SPOT.APB.date),2002:1:2019+1);
binned.year.CTD = histcounts(year(wod.SPOT.CTD.date),2002:1:2019+1);
binned.year.GLD = histcounts(year(wod.SPOT.GLD.date),2002:1:2019+1);
binned.year.OSD = histcounts(year(wod.SPOT.OSD.date),2002:1:2019+1);
binned.year.PFL = histcounts(year(wod.SPOT.PFL.date),2002:1:2019+1);
binned.year.all = binned.year.APB + binned.year.CTD + binned.year.GLD + binned.year.OSD + binned.year.PFL;

%% Number of unique TOPPids per year from SPOT.

yyyy = unique(year(pfl.SPOT.DateTime));
yyyy = yyyy(1):1:yyyy(end);
cnt_SPOT = zeros(length(yyyy),1);
for i = 1:length(yyyy)
    cnt_SPOT(i) = length(unique(pfl.SPOT.toppID(year(pfl.SPOT.DateTime) == yyyy(i))));
end
clear i

%% Number of unique TOPPids per year from SPOT+PAT.

cnt_PDT = zeros(length(yyyy),1);
for i = 1:length(yyyy)
    cnt_PDT(i) = length(unique(pfl.PDT.toppID(year(pfl.PDT.DateTime) == yyyy(i))));
end
clear i

for i = 1:length(pfl.PAT)
    tmp = unique(year(pfl.PAT(i).start_time));
    for j = 1:length(tmp)
        if tmp(j) == 2002
            cnt_PDT(1) = cnt_PDT(1)+1;
        elseif tmp(j) == 2003
            cnt_PDT(2) = cnt_PDT(2)+1;
        elseif tmp(j) == 2004
            cnt_PDT(3) = cnt_PDT(3)+1;
        elseif tmp(j) == 2005
            cnt_PDT(4) = cnt_PDT(4)+1;
        elseif tmp(j) == 2006
            cnt_PDT(5) = cnt_PDT(5)+1;
        elseif tmp(j) == 2007
            cnt_PDT(6) = cnt_PDT(6)+1;
        elseif tmp(j) == 2008
            cnt_PDT(7) = cnt_PDT(7)+1;
        end
    end
end
clear i
clear j

clear yyyy
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

bar(2002:1:2019,[binned.year.sharkPAT_PDT; binned.year.sharkCTD; binned.year.all].','hist');

set(gca,'FontSize',20);
xlabel('Year','FontSize',24);
ylabel('Number of Profiles','FontSize',24);

hold on

colororder({'k','k'})
yyaxis right

% number of tagged sharks per year
plot(2002:1:2019,cnt_SPOT,'o--','LineWidth',2);

hold on

plot(2002:1:2019,cnt_PDT,'*-','LineWidth',2);
ylabel('Number of Tagged Sharks','FontSize',24);

legend('PAT','CTD-SRDL','WOD','SPOT','SPOT+PAT','NumColumns',2);

xlim([2001 2020]);
colormap(cmap);

%% Save.

cd([folder '/figures']);
saveas(gcf,'histo_pfl_cnt_year.fig');
exportgraphics(gcf,'hist_pfl_cnt_year.png','Resolution',300)

close all

%% Number of PDTs as well as potential profiles by SPOT-tagged sharks and in WOD by platform.

figure('Position',[720 115 1136 420]);

bar(2002:1:2019,[binned.year.sharkPDT; binned.year.sharkPAT; binned.year.sharkCTD; ...
    binned.year.APB; binned.year.CTD; binned.year.GLD; binned.year.OSD; ...
    binned.year.PFL].','hist');

set(gca,'FontSize',20);
xlabel('Year','FontSize',24);
ylabel('Number of Profiles','FontSize',24);

hold on

colororder({'k','k'})
yyaxis right

% number of tagged sharks per year
plot(2002:1:2019,cnt_SPOT,'o--','LineWidth',2);

hold on

plot(2002:1:2019,cnt_PDT,'*-','LineWidth',2);
ylabel('Number of Tagged Sharks','FontSize',24);

legend('PDT','PAT','CTD-SRDL','APB','CTD','GLD','OSD','PFL','SPOT','SPOT+PAT','NumColumns',3);

xlim([2001 2020]);
colormap([cmap; [253,180,98]./256; [255,255,179]./256;...
    [188,128,189]./256; [252,205,229]./256; [217,217,217]./256]);

clear cmap

%% Save

cd([folder '/figures']);
saveas(gcf,'histo_pfl_cnt_year_by_platform.fig');
exportgraphics(gcf,'hist_pfl_cnt_year_by_platform.png','Resolution',300)

close all

%% Clear

clear cnt*