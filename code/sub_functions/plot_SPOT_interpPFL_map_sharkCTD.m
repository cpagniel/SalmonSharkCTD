%% plot_SPOT_interpPFL_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot estimated potential 
% number of profiles from SPOT tags.

%% Calculate number of profiles in each 0.5 deg latitude and longitude bin.

% expand edges such that plotting has no white spots except when bins are
% empty
binned.LONedges = -152:0.5:-124.5; 
binned.LATedges = 49.5:0.5:60.5;

[binned.sharkCTD.N,~,~,binned.sharkCTD.indLON,binned.sharkCTD.indLAT] = ...
    histcounts2(pfl.SPOT.Longitude,pfl.SPOT.Latitude,binned.LONedges,binned.LATedges);

binned.LONmid = diff(binned.LONedges)/2 + -152:0.5:-124.5;
binned.LATmid = diff(binned.LATedges)/2 + 49.5:0.5:60.5;

%% Create figure and projection.

figure('Position',[476 334 716 532]);

LATLIMS = [50 60]; LONLIMS = [-150 -125];
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

%% Plot bin map.

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.sharkCTD.N.');

h = colorbar('southoutside','FontSize',18);
ylabel(h,'Potential Number of Temperature-Salinity Profiles from 2002 to 2019','FontSize',20);
colormap([1 1 1; cmocean('haline',24)]);
caxis([0 25]);

hold on

%% Plot land.

m_gshhs_i('patch',[.7 .7 .7]);

hold on

%% Create grid, north arrow and ruler.

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);

m_northarrow(-126.2,58.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

%% Adjust plot position.

p = get(gca,'Position');
h.Position = h.Position + [.05 -.02 -.1 0];
set(gca,'Position',p);

%% Add total number of profiles.

pfl.SPOT.N = length(pfl.SPOT.Latitude);
m_text(-130.75,57,['n = ' num2str(pfl.SPOT.N)],'fontsize',20,'fontweight','bold');

%% Save

cd([folder '/figures']);
saveas(gcf,'SPOT_interpPFL_map_25.fig');
exportgraphics(gcf,'SPOT_interpPFL_map_25.png','Resolution',300)

%% Change colormap limits.

colormap([1 1 1; cmocean('haline',49)]);
caxis([0 50]);

%% Save

saveas(gcf,'SPOT_interpPFL_map_50.fig');
exportgraphics(gcf,'SPOT_interpPFL_map_50.png','Resolution',300)

close all

%% Clear

clear ans
clear h
clear p