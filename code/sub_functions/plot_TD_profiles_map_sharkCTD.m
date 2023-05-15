%% plot_TD_profiles_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot location of temperature-depth 
% profiles from recovered PAT tags on a map. Only plot Gulf of Alaska.

%% Create figure and axes for bathymetry.

figure;
ax1 = axes;

%% Create projection.

m_proj('lambert','long',[-150 -125],'lat',[50 60],'rectbox','off');

%% Plot bathymetry.

[CS,CH] = m_etopo2('contourf',[-6000:1000:-2000 -1000:400:-400 -200 -100 0 ],'edgecolor','none');

[ax,~] = m_contfbar([.65 .85],.73,CS,CH,'endpiece','no','axfrac',.05,'levels',[-6000 -1000 0]);
title(ax,'Bottom Depth (m)');

colormap(m_colmap('blues'));
caxis([-6000 000]);

hold on

%% Plot land.

m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

hold on

%% Create grid.

m_grid('linest','none','tickdir','out','box','fancy','fontsize',16);
m_northarrow(-149,50.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

hold on

%% Maker for legend.

m1 = m_plot(0,0,'o','LineWidth',1.5,'MarkerEdgeColor','k','MarkerSize',8);

hold on

%% Create second axes for temperature-depth profiles.

ax2 = axes;

%% Create projection.

m_proj('lambert','long',[-150 -125],'lat',[50 60],'rectbox','off');

%% Plot temperature-depth profiles colored by date.

for i = 1:length(toppID.pat)
    m_scatter(pfl.PAT(i).Longitude(pfl.PAT(i).DepthRange > 10),...
        pfl.PAT(i).Latitude(pfl.PAT(i).DepthRange > 10),...
        10,...
        datenum(pfl.PAT(i).start_time(pfl.PAT(i).DepthRange > 10)),...
        'filled','o');
    hold on
end
clear i

hold on

%% Link axes.

linkaxes([ax1,ax2]);
ax2.Visible = 'off';

%% Set colormap of date.

colormap(ax2,parula);
caxis([datenum(datetime(2002,7,16)) datenum(datetime(2008,5,19))]);

set(gcf,'color','none'); set(gca,'color','none');
m_grid('linest','none','tickdir','out','box','fancy','fontsize',16);
set(gca,'color','w'); set(gcf,'color','w');

%% Create colorbar for date.

C = colorbar('northoutside','FontSize',11,'FontWeight','bold');
cbdate('mm/yy');
C.Position(1) = 0.25; C.Position(2) = 0.88; C.Position(3) = 0.5;
xlabel(C,'Date (month/year)');

%% Save.

cd([folder '/figures']);
saveas(gcf,'TD_profile_map.fig');
exportgraphics(gcf,'TD_profiles_map.png','Resolution',300);

close all

%% Clear

clear ans
clear ax*
clear C*
clear h*
clear m*