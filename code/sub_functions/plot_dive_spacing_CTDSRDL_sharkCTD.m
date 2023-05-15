%% plot_dive_spacing_CTDSRDL_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot histograms of spatial and temporal
% dive spacing for CTD-SRDL shark tag.

%% Compute the time (in hours) between successive profile locations.

om.dtime = hours(diff(datetime(shark.corr.datenum,'ConvertFrom','datenum'))); % hours

%% Define bins for histograms. Bins of 2.5 hrs and 2.5 km are used. 

binned.Xedges = 0:2.5:30;
binned.Yedges = 0:2.5:100;

binned.N = histcounts2(om.dtime,om.range,binned.Xedges,binned.Yedges);

%% Calculate mode and 50% percentile.

stats.CTDSRDL.dtime.mode = mode(hours(roundn(om.dtime,-1)));
stats.CTDSRDL.dtime.prc50 = prctile(hours(roundn(om.dtime,-1)),50);
stats.CTDSRDL.dtime.sub = sum(om.dtime <= 24)/(length(om.dtime))*100;

stats.CTDSRDL.range.mode = mode(roundn(om.range,-2));
stats.CTDSRDL.range.prc50 = prctile(roundn(om.range,-2),50);
stats.CTDSRDL.range.sub = sum(om.range <= spacing.mean_full_km+spacing.std_full_km)/(length(om.range))*100;

%% Plot spatial and temporal resolution of CTD profiles with limited extents.

figure;

%% Central heatmap.

ax1 = subplot(3,3,[4 5 7 8]);

imagesc(binned.Xedges,binned.Yedges,binned.N);
set(gca,'ydir','normal','FontSize',14);

h = colorbar; 
colormap(hot(10)); 
ylabel(h,'Number of Profiles','FontSize',16);
caxis([0 10]);

xlabel('Time Between Profiles (hr)'); ylabel('Distance Between Profiles (km)');
xlim([0 30]); ylim([0 100]);
xticks(0:5:30);

hold on

% submesoscale resolving limits
plot([0 30],(spacing.mean_full_km+spacing.std_full_km)*ones(2,1),'r-','LineWidth',2) % full-depth Rossby radius of deformation
plot([24 24],[0 100],'r-','LineWidth',2) % 24 hours

hold on

% distribution statistics
plot(hours(stats.CTDSRDL.dtime.prc50)*ones(2,1),[0 100],'k--','LineWidth',2); % 50 percentile temporal
plot([0 30],stats.CTDSRDL.range.prc50*ones(2,1),'k--','LineWidth',2); % 50 percentile spatial

p1 = get(gca,'Position');

%% Temporal histogram.

ax2 = subplot(3,3,1:2);

histogram(om.dtime,binned.Xedges,'FaceColor',[0.7 0.7 0.7]);

set(gca,'XTickLabel','','Box','Off','FontSize',14);
ylabel('Number of Profiles','FontSize',16)
xlim([0 30]);

hold on

% submesoscale resolving limit
plot([24 24],[0 20],'r-','LineWidth',2); % 24 hours

hold on

% distribution statistics
plot(hours(stats.CTDSRDL.dtime.mode),20,'ko','MarkerFaceColor','k'); % mode temporal
plot(hours(stats.CTDSRDL.dtime.prc50)*ones(2,1),[0 20],'k--','LineWidth',2); % 50 percentile temporal

p2 = get(gca,'Position'); p2(3) = p1(3);
set(gca,'Position',p2);

%% Spatial hisotgram.

ax3 = subplot(3,3,[6 9]);

histogram(om.range,binned.Yedges,'FaceColor',[0.7 0.7 0.7]);

set(gca,'XTickLabel','','Box','Off','FontSize',14);
ylabel('Number of Profiles','FontSize',16)
xlim([0 100]);

hold on

% submesoscale resolving limit
plot((spacing.mean_full_km+spacing.std_full_km)*ones(2,1),[0 12],'r-','LineWidth',2); % full-depth Rossby deformation radius

% distribution statistics
plot(stats.CTDSRDL.range.mode,12,'ko','MarkerFaceColor','k'); % mode spatial
plot(stats.CTDSRDL.range.prc50*ones(2,1),[0 12],'k--','LineWidth',2); % 50 percentile spatial

p3 = get(gca,'Position'); p3(4) = p1(4); p3(1) = p3(1)-0.1;
set(gca,'Position',p3);
view(90,-90);

pl = h.Position; pl(1) = pl(1)+0.3;
set(h,'Position',pl);

set(ax1,'Position',p1);

%% Save.

cd([folder '/figures']);
saveas(gcf,'dive_spacing_CTDSRDL.fig');
exportgraphics(gcf,'dive_spacing_CTDSRDL.png','Resolution',300);

close all

%% Clear

clear ax* 
clear binned
clear h* 
clear p1 p2 p3 pl