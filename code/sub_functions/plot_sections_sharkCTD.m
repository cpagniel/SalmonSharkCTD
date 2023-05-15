%% plot_sections_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot sections from objectively mapped
% CTD-SRDL data from shark fin tag.

%% Plot conservative temperature section with MLD.

figure('Position',[161 310 1181 420]);

pcolor(om.x,om.z,vis.CT);
shading flat;

hold on

plot(repmat([0; om.dist].',[size(shark.raw.p,1),1]),shark.raw.p,'w.') % 16 cut points

hold on

m1 = plot(om.x,oce.mld(:,1),'k-','LineWidth',2); % MLD

xlabel('Along-Track Distance (km)','Fontsize',24); ylabel('Depth (m)','Fontsize',24);
set(gca,'ydir','reverse','FontSize',18);

h = colorbar; ylabel(h,'{\Theta} ({\circ}C)','Fontsize',24);
cmocean thermal; 
caxis([2 18]);

% legend(m1,'Mixed Layer Depth (m)','Location','Best','FontSize',12)

%% Save.

cd([folder '/figures']);
saveas(gcf,'CT_section.fig');
exportgraphics(gcf,'CT_section.png','Resolution',300);

close all

%% Clear

clear h
clear m1

%% Plot absolute salinity section with MLD. 

figure('Position',[161 310 1181 420]);

pcolor(om.x,om.z,vis.SA);
shading flat;

hold on

plot(repmat([0; om.dist].',[size(shark.raw.p,1),1]),shark.raw.p,'w.') % 16 cut points

hold on

m1 = plot(om.x,oce.mld(:,1),'k-','LineWidth',2); % MLD

xlabel('Along-Track Distance (km)','Fontsize',24); ylabel('Depth (m)','Fontsize',24);
set(gca,'ydir','reverse','FontSize',18);

h = colorbar; ylabel(h,'\it{S}\rm_A (g/kg)','Fontsize',24);
cmocean haline; 
caxis([31.5 34.5]);

% legend(m1,'Mixed Layer Depth (m)','Location','Best','FontSize',12)

%% Save.

cd([folder '/figures']);
saveas(gcf,'SA_section.fig');
exportgraphics(gcf,'SA_section.png','Resolution',300);

close all

%% Clear

clear h
clear m1