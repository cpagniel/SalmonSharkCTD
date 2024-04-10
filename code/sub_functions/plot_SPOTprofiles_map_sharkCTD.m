%% plot_SPOTprofiles_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot location of potential 
% profiles from SPOT tags on a map. Only plot Gulf of Alaska.

%% Create figure and axes for bathymetry.

figure;

%% Create projection.

LATLIMS = [50 60]; LONLIMS = [-150 -125];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

%% Plot land.

m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

hold on

%% Set colormap.

yy = [2002:2010 2012 2015];
cmap = getPyPlot_cMap('gist_ncar',length(yy));

%% Get all toppIDs.

tmp = unique(pfl.SPOT.toppID);

% random order by toppID
tmp_rand = tmp(randperm(length(tmp)));

%% Plot potential profile locations.

for i = 1:length(tmp_rand)
    m_line(pfl.SPOT.Longitude(pfl.SPOT.toppID == tmp_rand(i)),pfl.SPOT.Latitude(pfl.SPOT.toppID == tmp_rand(i)),'Color',cmap(min(year(pfl.SPOT.DateTime(pfl.SPOT.toppID == tmp_rand(i)))) == yy,:));
    hold on

    m_plot(pfl.SPOT.Longitude(pfl.SPOT.toppID == tmp_rand(i)),pfl.SPOT.Latitude(pfl.SPOT.toppID == tmp_rand(i)),'ko','MarkerFaceColor',cmap(min(year(pfl.SPOT.DateTime(pfl.SPOT.toppID == tmp_rand(i)))) == yy,:),'MarkerSize',4);
    hold on
end

hold on

for i = 1:length(yy)
    m(i) = m_plot(-100,100,'o','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor','k','MarkerSize',5,'LineWidth',1);
end
clear i

clear tmp*

%% Create border.

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',19);

m_northarrow(-126.2,58.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

%% Save.

cd([folder '/figures']);
saveas(gcf,'SPOT_track_map.fig');
exportgraphics(gcf,'SPOT_track_map.png','Resolution',300);

%% Legend.

[~,icon] = legend(m,str2cell(string(yy)),'Position',[0.88, 0.425, 0.05, 0.25],...
    'FontSize',11);
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',8);

clear yy
clear icon*

%% Save.

cd([folder '/figures']);
saveas(gcf,'SPOT_track_map_with_legend.fig');
exportgraphics(gcf,'SPOT_track_map_with_legend.png','Resolution',300);

close all

%% Clear

clear ans
clear ax*
clear C*
clear h*
clear m*