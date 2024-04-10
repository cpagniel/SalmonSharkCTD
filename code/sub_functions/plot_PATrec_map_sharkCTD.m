%% plot_PATrec_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot location of temperature-depth 
% profiles from recovered PAT tags on a map. Only plot Gulf of Alaska.

%% Create figure and axes for bathymetry.

figure;

%% Create projection.

m_proj('lambert','long',[-150 -125],'lat',[50 61.5],'rectbox','off');

%% Plot bathymetry.

[CS,CH] = m_etopo2('contourf',[-6000:1000:-2000 -1000:400:-400 -200 -100 0 ],'edgecolor','none');

[ax,~] = m_contfbar([.65 .85],.79,CS,CH,'endpiece','no','axfrac',.05,'levels',[-6000 -1000 0]);
title(ax,'Bottom Depth (m)');

colormap(m_colmap('blues'));
caxis([-6000 0]);

hold on

%% Plot land.

m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

hold on

%% Plot temperature-depth profiles.

for i = 1:length(toppID.pat)

    h2(i) = m_line(pfl.PAT(i).Longitude(pfl.PAT(i).DepthRange > 10),...
        pfl.PAT(i).Latitude(pfl.PAT(i).DepthRange > 10),...
        'marker','o','Color','r','linewi',3,'linest','none','markersize',7,'markerfacecolor','w');

    hold on
end
clear i

hold on

%% Create border.

m_grid('linest','none','tickdir','out','box','fancy','fontsize',20);
m_northarrow(-149,50.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

%% Legend.

[~,icon] = legend(h2(1),'PAT Profiles', ...
    'Position',[0.6125 0.67 0.1982 0.045]);
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',8);

clear icon*

%% Save.

cd([folder '/figures']);
saveas(gcf,'PATrec_map.fig');
exportgraphics(gcf,'PATrec_map.png','Resolution',300);

close all

%% Clear

clear ans
clear ax*
clear C*
clear h*
clear m*