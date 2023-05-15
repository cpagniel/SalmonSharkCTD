%% plot_anom_sections_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot section of CT and SA anomalies
% with mixed layer depth along shark's trajectory.

%% Plot section of CT anomalies.

figure('Position',[161 310 1181 420]);

pcolor(om.x,om.z.',anom.vis.CT);
shading flat

h = colorbar; ylabel(h,'{\Theta}_{anom} ({\circ}C)','FontSize',24);
cmocean('balance',16); caxis([-4 4]);

hold on

m1 = plot(om.x,oce.mld(:,1),'k-','LineWidth',2); % MLD

xlabel('Along-Track Distance (km)','FontSize',24); ylabel('Depth (m)','FontSize',24);
set(gca,'ydir','reverse','FontSize',18);

%% Save.

cd([folder '/figures'])
saveas(gcf,'CT_anom_section.fig');
exportgraphics(gcf,'CT_anom_section.png','Resolution',300);

close all

%%

figure('Position',[161 310 1181 420]);

pcolor(om.x,om.z.',anom.vis.SA);
shading flat

h = colorbar; ylabel(h,'\it{S}\rm_A_{ anom} (g/kg)','FontSize',24);
cmocean('curl',16); caxis([-2 2]);

hold on

m1 = plot(om.x,oce.mld(:,1),'k-','LineWidth',2); % MLD

xlabel('Along-Track Distance (km)','FontSize',24); ylabel('Depth (m)','FontSize',24);
set(gca,'ydir','reverse','FontSize',18);

%% Save.

cd([folder '/figures'])
saveas(gcf,'SA_anom_section.fig');
exportgraphics(gcf,'SA_anom_section.png','Resolution',300);

close all

%% Clear 

clear h
clear m1