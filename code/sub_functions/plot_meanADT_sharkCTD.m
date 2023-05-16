%% plot_meanADT_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot mean absolute dynamic topography
% with shark trajectory. Locations on shark trajectory are colored by eddy
% type.

%% Create figure and projection.

figure;
m_proj('lambert','long',[-150 -125],'lat',[50 60],'rectbox','off');

%% Plot mean absolute dynamic topography.

m_pcolor(sat.lon,sat.lat,mean(sat.adt(:,:,3:end),3).');
shading flat;

cmocean('balance');
h = colorbar('southoutside','FontSize',18,'Ticks',0.25:0.1:0.75);
ylabel(h,'Mean Absolute Dynamic Topography (m)','FontSize',20);
caxis([0.25 0.75]);

hold on

%% Plot land.

m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

hold on

%% Plot ARGOS positions colored by eddy type.

m_plot(argos.lon(argos.qual >= 1),argos.lat(argos.qual >= 1),'ko-','markersize',5,'markerfacecolor','k');
m_plot(argos.lon(argos.qual >= 1 & argos.eddy.type.' == 1),argos.lat(argos.qual >= 1 & argos.eddy.type.' == 1),'ro','markersize',5,'markerfacecolor','r');
m_plot(argos.lon(argos.qual >= 1 & argos.eddy.type.' == 0),argos.lat(argos.qual >= 1 & argos.eddy.type.' == 0),'bo','markersize',5,'markerfacecolor','b');

hold on

%% Plot shark-collected CTD locations colored by eddy type.

m_line(shark.corr.lon(isnan(shark.eddy.type)),shark.corr.lat(isnan(shark.eddy.type)),'marker','o','Color','k','linewi',3,'linest','none','markersize',7,'markerfacecolor','w');
m_line(shark.corr.lon(shark.eddy.type == 1),shark.corr.lat(shark.eddy.type == 1),'marker','o','Color','r','linewi',3,'linest','none','markersize',7,'markerfacecolor','w');
m_line(shark.corr.lon(shark.eddy.type == 0),shark.corr.lat(shark.eddy.type == 0),'marker','o','Color','b','linewi',3,'linest','none','markersize',7,'markerfacecolor','w');

hold on

%% Plot markers for legend.

h1 = m_line(0,0,'marker','o','Color','k','linewi',3,'linest','none','markersize',7,'markerfacecolor','w');
h2 = m_line(0,0,'marker','o','Color','r','linewi',3,'linest','none','markersize',7,'markerfacecolor','w');
h3 = m_line(0,0,'marker','o','Color','b','linewi',3,'linest','none','markersize',7,'markerfacecolor','w');

hold on

%% Create grid.

m_grid('linest','none','tickdir','out','box','fancy','fontsize',20);
m_northarrow(-149,50.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

hold on

%% Adjust axes.

p = get(gca,'Position');
h.Position = h.Position + [.05 -.01 -.1 0];
set(gca,'Position',p);

hold on

%% Create legend.

legend([h2,h3,h1],'ACE','CE','Outside of Eddy','Position',[0.5581 0.7420 0.2536 0.1333],'FontSize',14);

%% Save.

cd([folder '/figures']);
saveas(gcf,'meanADT_larger.fig');
exportgraphics(gcf,'meanADT_larger.png','Resolution',300);

close all

%% Clear

clear ans
clear h*
clear p