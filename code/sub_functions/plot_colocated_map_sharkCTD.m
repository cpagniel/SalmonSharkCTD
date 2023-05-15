%% plot_colocated_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot map of co-located shark-collected 
% and Argo profiles.

%% Create figure and projection.

figure('color','w');
m_proj('lambert','long',[-150 -125],'lat',[49.7 60],'rectbox','off');

%% Plot bathymetry.

[CS,CH] = m_etopo2('contourf',[-6000:1000:-2000 -1000:400:-400 -200 -100 0 ],'edgecolor','none');

[ax,~] = m_contfbar([.65 .85],.73,CS,CH,'endpiece','no','axfrac',.05,'levels',[-6000 -1000 0]);
title(ax,'Bottom Depth (m)');

colormap(m_colmap('blues'));
caxis([-6000 000]);

%% Plot land.

m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

%% Plot location of shark-collected profiles.

for i = 1:length(wod.CTDSRDL.all.indx)
    if ~isnan(shark.corr.lon(i))
        dt = day(shark.corr.datetime(wod.CTDSRDL.all.indx(i)) - shark.corr.datetime(1)) + 1;

        h1(i) = m_line(shark.corr.lon(wod.CTDSRDL.all.indx(i)),shark.corr.lat(wod.CTDSRDL.all.indx(i)),...
            'marker','o','Color',cmap(dt,:),'linewi',2,'linest','none','markersize',4,'markerfacecolor','w');
        
        hold on
    end
end
clear i 
clear dt

%% Plot location of Argo profiles

h2 = m_line(wod.CTDSRDL.PFL.lon(wod.CTDSRDL.all.indy),wod.CTDSRDL.PFL.lat(wod.CTDSRDL.all.indy),'marker','o',...
    'color','k','linewi',2,'linest','none','markersize',4,'markerfacecolor','w');

hold on

%% Create grid.

m_grid('linest','none','tickdir','out','box','fancy','fontsize',16);
m_northarrow(-149,50.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

%% Add legend.

legend([h1(1),h2(1)],'Shark Profiles','Argo Profiles','Position',[0.6268 0.6054 0.1732 0.0631]);

%% Save.

cd([folder '/figures'])
saveas(gcf,'Argo_vs_Shark_map.fig');
exportgraphics(gcf,'Argo_vs_Shark_map.png','Resolution',300);

close all

%% Clear

clear ans
clear ax 
clear C* 
clear h* 
