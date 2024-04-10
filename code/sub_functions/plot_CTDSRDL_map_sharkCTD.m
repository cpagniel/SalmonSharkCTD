%% plot_CTDSRDL_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot map with CTD-SRDL shark fin tag
% profile locations

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

%% Plot ARGOS locations from CTD-SRDL.

for i = 1:length(shark.corr.datenum)
    if ~isnan(shark.corr.lon(i))
        dt = day(shark.corr.datetime(i) - shark.corr.datetime(1)) + 1;

        h2(i) = m_line(shark.corr.lon(i),shark.corr.lat(i),'marker','o','Color','r','linewi',3,'linest','none','markersize',7,'markerfacecolor','w');

        hold on

    end
end
clear i

%% Create border.

m_grid('linest','none','tickdir','out','box','fancy','fontsize',20);
m_northarrow(-149,50.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

%% Legend.

[~,icon] = legend(h2(1),'CTD-SRDL Profiles', ...
    'Position',[0.6125 0.67 0.1982 0.045]);
icons = findobj(icon, 'type', 'line');
set(icons,'MarkerSize',8);

%% Save.

cd([folder '/figures']);
saveas(gcf,'CTDSRDL_map_largest.fig');
exportgraphics(gcf,'CTDSRDL_map_largest.png','Resolution',300)

close all

%% Clear.

clear ax 
clear ans
clear C* 
clear dt
clear h* 
clear i*