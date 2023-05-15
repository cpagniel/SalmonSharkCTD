%% plot_PDT_PAT_map_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot bin map of PDTs and profiles from
% recovered PAT tags.

%% Combine PDTs and profiles from recovered PATs into single vector.

tmp.PAT.lat = [pfl.PAT.Latitude].'; tmp.PAT.lon = [pfl.PAT.Longitude].';
tmp.PAT.date = vertcat(pfl.PAT.start_time);
tmp.PAT.depth = vertcat(pfl.PAT.DepthRange); 

% Only keep profiles deeper than 24 m.
ind = tmp.PAT.depth >= 24;
tmp.PAT.lat(~ind) = []; tmp.PAT.lon(~ind) = []; 
tmp.PAT.date(~ind) = [];
tmp.PAT.depth(~ind) = [];
clear ind

ind_lon = tmp.PAT.lon <= -125 & tmp.PAT.lon >= -150; ind_lat = tmp.PAT.lat >= 50 & tmp.PAT.lat <= 60;
ind = ind_lon + ind_lat == 2;

pfl.PAT_PDT.Latitude = [tmp.PAT.lat(ind); pfl.PDT.Latitude];
pfl.PAT_PDT.Longitude = [tmp.PAT.lon(ind); pfl.PDT.Longitude];
pfl.PAT_PDT.DateTime = [tmp.PAT.date(ind); pfl.PDT.DateTime];

clear tmp
clear ind*

%% Calculate number of profiles in each 0.5 deg latitude and longitude bin.

[binned.sharkPDT.N,~,~,binned.sharkPDT.indLON,binned.sharkPDT.indLAT] = ...
    histcounts2(pfl.PAT_PDT.Longitude,pfl.PAT_PDT.Latitude,binned.LONedges,binned.LATedges);

%% Create figure and projection.

figure('Position',[476 334 716 532]);

m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

%% Plot bin map.

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.sharkPDT.N.');

h = colorbar('southoutside','FontSize',18);
ylabel(h,'Number of Temperature Profiles from 2002 to 2008','FontSize',20);
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

pfl.PAT_PDT.N = length(pfl.PAT_PDT.Latitude);
m_text(-130.75,57,['n = ' num2str(pfl.PAT_PDT.N)],'fontsize',20,'fontweight','bold');

%% Save

cd([folder '/figures']);
saveas(gcf,'PAT_PDT_map_25.fig');
exportgraphics(gcf,'PAT_PDT_map_25.png','Resolution',300)

%% Change colormap limits.

colormap([1 1 1; cmocean('haline',49)]);
caxis([0 50]);

%% Save

saveas(gcf,'PAT_PDT_map_50.fig');
exportgraphics(gcf,'PAT_PDT_map_50.png','Resolution',300)

close all

%% Clear

clear ans
clear h
clear p