%% plot_WOD_2002_to_2019_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot bin map of all WOD between 2002
% and 2019 on days sharks were present in the Gulf of Alaska.

%% Calculate number of profiles in each 0.5 deg latitude and longitude bin.

[binned.wod.N,~,~,binned.wod.indLON,binned.wod.indLAT] = histcounts2(...
    [wod.SPOT.APB.lon; wod.SPOT.CTD.lon; wod.SPOT.GLD.lon; wod.SPOT.OSD.lon; wod.SPOT.PFL.lon],...
    [wod.SPOT.APB.lat; wod.SPOT.CTD.lat; wod.SPOT.GLD.lat; wod.SPOT.OSD.lat; wod.SPOT.PFL.lat],...
    binned.LONedges,binned.LATedges);

%% Create figure and projection.

figure('Position',[476 334 716 532]);

m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

%% Plot bin map.

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.wod.N.');

h = colorbar('southoutside','FontSize',18);
ylabel(h,'Number of Temperature-Salinity Profiles from 2002 to 2019','FontSize',20);
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

m_text(-130.75,57,['n = ' num2str(wod.SPOT.APB.n + wod.SPOT.CTD.n + wod.SPOT.GLD.n + wod.SPOT.OSD.n + wod.SPOT.PFL.n)],'fontsize',20,'fontweight','bold')

%% Save

cd([folder '/figures']);
saveas(gcf,'WOD_all_map_25.fig');
exportgraphics(gcf,'WOD_all_map_25.png','Resolution',300)

%% Change colormap limits.

colormap([1 1 1; cmocean('haline',49)]);
caxis([0 50]);

%% Save

saveas(gcf,'WOD_all_map_50.fig');
exportgraphics(gcf,'WOD_all_map_50.png','Resolution',300)

close all

%% Clear

clear ans
clear h
clear p