%% plot_diff_WOD_SPOT_interpPFL_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot difference between number of WOD 
% CTD profiles between 2002 and 2019 on days sharks were present in the Gulf 
% of Alaska and estimated number of profiles from SPOT tags.

%% Create figure and projection.

figure('Position',[476 334 716 532]);

m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

%% Plot difference.

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.wod.N.'-binned.sharkCTD.N.')

h = colorbar('southoutside','FontSize',18);
y = ylabel(h,{'Number of Temperature-Salinity Profiles in WOD - Potential'; ...
    'Number Collected by SPOT-Tagged Sharks from 2002 to 2019'},'FontSize',20);
colormap(cmocean('delta',100));
caxis([-50 50]);

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

y.Position(2) = y.Position(2) + 0.45;

%% Save

cd([folder '/figures']);
saveas(gcf,'WOD-Shark_map.fig');
exportgraphics(gcf,'WOD-Shark_map.png','Resolution',300)

close all

%% Clear

clear ans
clear h
clear p
clear y