%% plot_SSSa_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot SSS monthly average anomaly data 
% for September.

%% Create figure and projection.

figure('color','w');
m_proj('lambert','long',[-180 -125],'lat',[30 60],'rectbox','off');

%% Plot SSS monthly average anomaly for September.

m_pcolor(sss.lon,sss.lat,squeeze(sss.anom).')

cmocean('curl',16);
h = colorbar('southoutside','FontSize',18);
ylabel(h,'Mean Monthly Sea Surface Salinity Anomaly','FontSize',20);
caxis([-2 2]);

clear y

hold on

%% Plot land.

m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

hold on

%% Plot ARGOS positions.

h1 = m_plot(argos.lon(argos.qual >= 1),argos.lat(argos.qual >= 1),'ko-','markersize',2,'markerfacecolor','k');

hold on

%% Plot shark-collected CTD locations.

for i = 1:length(shark.corr.datenum)
    if ~isnan(shark.corr.lon(i))
        dt = day(shark.corr.datetime(i) - shark.corr.datetime(1)) + 1;

        h2(i) = m_line(shark.corr.lon(i),shark.corr.lat(i),'marker','o','Color',cmap(dt,:),'linewi',2,'linest','none','markersize',4,'markerfacecolor','w');

    end
end
clear i
clear dt

hold on

%% Create grid.

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',22);
m_northarrow(-178.5,32,3,'type',2,'linewi',2);
m_ruler([.75 .92],.2,2,'fontsize',12,'ticklength',0.01);

hold on

%% Adjust axes.

p = get(gca,'Position');
h.Position = h.Position + [.05 -.01 -.1 0];
set(gca,'Position',p);

hold on

%% Plot legend.

l = legend([h1(1),h2(1)],'Shark Trajectory','Shark Profiles','Location','northwest');
l.Position(1) = 0.29; l.Position(2) = 0.82;

clear l

%% Save

cd([folder '/figures']);
saveas(gcf,'SSSa_September.fig');
exportgraphics(gcf,'SSSa_September.png','Resolution',300);

close all

%% Clear

clear ans
clear h*
clear p