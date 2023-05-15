%% plot_WOD_2002_to_2019_map_by_platform_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot bin maps of profiles from the
% World Ocean Database beween 2002 and 2019 on days that sharks were
% present in the Gulf of Alaska by platform.

%% Calculate number of profiles in each 0.5 deg latitude and longitude bin.

[binned.apb.N,~,~,binned.apb.indLON,binned.apb.indLAT] = histcounts2(wod.SPOT.APB.lon,wod.SPOT.APB.lat,binned.LONedges,binned.LATedges);
[binned.ctd.N,~,~,binned.ctd.indLON,binned.ctd.indLAT] = histcounts2(wod.SPOT.CTD.lon,wod.SPOT.CTD.lat,binned.LONedges,binned.LATedges);
[binned.gld.N,~,~,binned.gld.indLON,binned.gld.indLAT] = histcounts2(wod.SPOT.GLD.lon,wod.SPOT.GLD.lat,binned.LONedges,binned.LATedges);
[binned.osd.N,~,~,binned.osd.indLON,binned.osd.indLAT] = histcounts2(wod.SPOT.OSD.lon,wod.SPOT.OSD.lat,binned.LONedges,binned.LATedges);
[binned.pfl.N,~,~,binned.pfl.indLON,binned.pfl.indLAT] = histcounts2(wod.SPOT.PFL.lon,wod.SPOT.PFL.lat,binned.LONedges,binned.LATedges);

%% APB

figure('Position',[476 334 716 532]);
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.apb.N.');
h = colorbar('southoutside','FontSize',18);
ylabel(h,'Number of Temperature-Salinity Profiles from 2002 to 2019','FontSize',20);
colormap([1 1 1; cmocean('haline',24)]);
caxis([0 25]);

hold on

m_gshhs_i('patch',[.7 .7 .7]);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);
m_northarrow(-126.2,58.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',14,'ticklength',0.01);

p = get(gca,'Position');
h.Position = h.Position + [.05 -.02 -.1 0];
set(gca,'Position',p);

m_text(-130.75,57,['n = ' num2str(wod.SPOT.APB.n)],'fontsize',20,'fontweight','bold');

cd([folder '/figures']);
saveas(gcf,'WOD_APB_map.fig');
exportgraphics(gcf,'WOD_APB_map.png','Resolution',300);

close all

clear ans
clear h
clear p

%% CTD

figure('Position',[476 334 716 532]);
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.ctd.N.');
h = colorbar('southoutside','FontSize',18);
ylabel(h,'Number of Temperature-Salinity Profiles from 2002 to 2019','FontSize',20);
colormap([1 1 1; cmocean('haline',24)]);
caxis([0 25]);

hold on

m_gshhs_i('patch',[.7 .7 .7]);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);
m_northarrow(-126.2,58.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',14,'ticklength',0.01);

p = get(gca,'Position');
h.Position = h.Position + [.05 -.02 -.1 0];
set(gca,'Position',p);

m_text(-130.75,57,['n = ' num2str(wod.SPOT.CTD.n)],'fontsize',20,'fontweight','bold');

cd([folder '/figures']);
saveas(gcf,'WOD_CTD_map.fig');
exportgraphics(gcf,'WOD_CTD_map.png','Resolution',300);

close all

clear ans
clear h
clear p

%% GLD

figure('Position',[476 334 716 532]);
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.gld.N.');
h = colorbar('southoutside','FontSize',18);
ylabel(h,'Number of Temperature-Salinity Profiles from 2002 to 2019','FontSize',20);
colormap([1 1 1; cmocean('haline',24)]);
caxis([0 25]);

hold on

m_gshhs_i('patch',[.7 .7 .7]);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);
m_northarrow(-126.2,58.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',14,'ticklength',0.01);

p = get(gca,'Position');
h.Position = h.Position + [.05 -.02 -.1 0];
set(gca,'Position',p);

m_text(-130.75,57,['n = ' num2str(wod.SPOT.GLD.n)],'fontsize',20,'fontweight','bold');

cd([folder '/figures']);
saveas(gcf,'WOD_GLD_map.fig');
exportgraphics(gcf,'WOD_GLD_map.png','Resolution',300);

close all

clear ans
clear h
clear p

%% OSD

figure('Position',[476 334 716 532]);
m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.osd.N.');
h = colorbar('southoutside','FontSize',18);
ylabel(h,'Number of Temperature-Salinity Profiles from 2002 to 2019','FontSize',20);
colormap([1 1 1; cmocean('haline',24)]);
caxis([0 25]);

hold on

m_gshhs_i('patch',[.7 .7 .7]);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);
m_northarrow(-126.2,58.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',14,'ticklength',0.01);

p = get(gca,'Position');
h.Position = h.Position + [.05 -.02 -.1 0];
set(gca,'Position',p);

m_text(-130.75,57,['n = ' num2str(wod.SPOT.OSD.n)],'fontsize',20,'fontweight','bold');

cd([folder '/figures']);
saveas(gcf,'WOD_OSD_map.fig');
exportgraphics(gcf,'WOD_OSD_map.png','Resolution',300);

close all

clear ans
clear h
clear p

%% PFL

figure('Position',[476 334 716 532]);

m_proj('lambert','lon',LONLIMS,'lat',LATLIMS);

m_pcolor(binned.LONmid-0.25,binned.LATmid-0.25,binned.pfl.N.');
h = colorbar('southoutside','FontSize',18);
ylabel(h,'Number of Temperature-Salinity Profiles from 2002 to 2019','FontSize',20);
colormap([1 1 1; cmocean('haline',24)]);
caxis([0 25]);

hold on

m_gshhs_i('patch',[.7 .7 .7]);

m_grid('linewi',2,'tickdir','in','linest','none','fontsize',24);
m_northarrow(-126.2,58.75,1,'type',2,'linewi',2);
m_ruler([.72 .87],.11,2,'fontsize',14,'ticklength',0.01);

p = get(gca,'Position');
h.Position = h.Position + [.05 -.02 -.1 0];
set(gca,'Position',p);

m_text(-130.75,57,['n = ' num2str(wod.SPOT.PFL.n)],'fontsize',20,'fontweight','bold');

cd([folder '/figures']);
saveas(gcf,'WOD_PFL_map.fig');
exportgraphics(gcf,'WOD_PFL_map.png','Resolution',300);

close all

clear ans
clear h
clear p