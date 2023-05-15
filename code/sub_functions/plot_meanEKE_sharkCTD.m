%% plot_meanEKE_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot mean eddy kinetic energy and 
% shark's trajectory.

%% Create figure and projection.

figure;
m_proj('lambert','long',[-150 -125],'lat',[50 60],'rectbox','off');

%% Plot EKE.

m_pcolor(sat.lon,sat.lat,mean(1/2*(sat.ugosa.^2 + sat.vgosa.^2),3).');
shading flat;

cmocean('matter');
h = colorbar('southoutside','FontSize',18,'Ticks',0:0.01:0.05);
y = ylabel(h,'Mean Eddy Kinetic Energy (m^2/s^2)','FontSize',20);
caxis([0 0.05]);

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

        hold on
    end
end
clear i
clear dt

hold on

%% Create grid.

m_grid('linest','none','tickdir','out','box','fancy','fontsize',16);
m_northarrow(-149,50.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

hold on

%% Adjust axes.

p = get(gca,'Position');
h.Position = h.Position + [.05 -.01 -.1 0];
set(gca,'Position',p);
y.Position(2) = y.Position(2) + 0.4;

hold on

%% Create legend.

legend([h1(1),h2(1)],'Shark Trajectory','Shark Profiles','Position',[0.6179 0.8128 0.1911 0.0631])

%% Save.

cd([folder '/figures']);
saveas(gcf,'meanEKE.fig');
exportgraphics(gcf,'meanEKE.png','Resolution',300)

close all

%% Clear

clear ans
clear h*
clear p
clear y