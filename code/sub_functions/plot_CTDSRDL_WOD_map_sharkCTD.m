%% plot_CTDSRDL_WOD_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot map with CTD-SRDL shark fin tag
% profile locations and WOD profile locations.

%% Create figure and projection.

figure('color','w');
m_proj('lambert','long',[-150 -125],'lat',[50 61.5],'rectbox','off');

%% Plot bathymetry.

[CS,CH] = m_etopo2('contourf',[-6000:1000:-2000 -1000:400:-400 -200 -100 0 ],'edgecolor','none');

[ax,~] = m_contfbar([.65 .85],.79,CS,CH,'endpiece','no','axfrac',.05,'levels',[-6000 -1000 0]);
title(ax,'Bottom Depth (m)');

colormap(m_colmap('blues'));
caxis([-6000 0]);

%% Plot land.

m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

%% Plot profile locations from the World Ocean Database.

m_line(wod.CTDSRDL.CTD.lon(wod.CTDSRDL.CTD.lat >= 50.1),wod.CTDSRDL.CTD.lat(wod.CTDSRDL.CTD.lat >= 50.1),'marker','o','color','k','linewi',2,'linest','none','markersize',6,'markerfacecolor','w');

hold on

h3 = m_line(wod.CTDSRDL.PFL.lon(wod.CTDSRDL.PFL.lat >= 50.1),wod.CTDSRDL.PFL.lat(wod.CTDSRDL.PFL.lat >= 50.1),'marker','o','color','k','linewi',2,'linest','none','markersize',6,'markerfacecolor','w');

hold on

%% Plot ARGOS locations from CTD-SRDL.

h1 = m_plot(argos.lon(argos.qual >= 1),argos.lat(argos.qual >= 1),'ko-','linewidth',2,'markersize',5,'markerfacecolor','k');

hold on

for i = 1:length(shark.corr.datenum)
    if ~isnan(shark.corr.lon(i))
        dt = day(shark.corr.datetime(i) - shark.corr.datetime(1)) + 1;

        h2(i) = m_line(shark.corr.lon(i),shark.corr.lat(i),'marker','o','Color',cmap(dt,:),'linewi',3,'linest','none','markersize',7,'markerfacecolor','w');

        hold on

    end
end
clear i

%% Plot tagging location.

h5 = m_plot(shark.raw.tagdeploy.lon,shark.raw.tagdeploy.lat,'marker','v','color','k','markersize',9,'markerfacecolor','w','linest','none','linewi',2);

hold on

%% Create border.

m_grid('linest','none','tickdir','out','box','fancy','fontsize',20);
m_northarrow(-149,50.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

%% Legend.

[~,icon] = legend([h5(1),h1(1),h2(1),h3(1)],'Tagging Location','Shark Trajectory','Shark Profiles','WOD Profiles', ...
    'Position',[0.6125 0.5589 0.1982 0.1452]);
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',8);

%% Save.

cd([folder '/figures']);
saveas(gcf,'CTDSRDL_WOD_map_largest.fig');
exportgraphics(gcf,'CTDSRDL_WOD_map_largest.png','Resolution',300)

close all

%% Clear.

clear ax 
clear ans
clear C* 
clear dt
clear h* 
clear i*