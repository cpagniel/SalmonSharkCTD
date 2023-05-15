%% plot_anom_dist_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot distribution of anomalies.

%% Plot distribution of temperature anomalies.

figure;

tmp = cmocean('balance',16);

histogram(anom.anom.CT(:),-4:0.5:4,'FaceColor',tmp(5,:),'FaceAlpha',1);

hold on

plot(mean(anom.anom.CT(:),'omitnan')*ones(2,1),[0 200],'k-','LineWidth',2)
plot((mean(anom.anom.CT(:),'omitnan')+std(anom.anom.CT(:),'omitnan'))*ones(2,1),[0, 200],'k--','LineWidth',2)
plot((mean(anom.anom.CT(:),'omitnan')-1*std(anom.anom.CT(:),'omitnan'))*ones(2,1),[0, 200],'k--','LineWidth',2)

xlabel('{\Theta}_{anom} ({\circ}C)','FontSize',20); ylabel('Counts','FontSize',20);
xlim([-4 4]); ylim([0 200]);
set(gca,'FontSize',18);
axis square;

clear tmp

%% Save.

cd([folder '/figures'])
saveas(gcf,'CT_anom_dist.fig');
exportgraphics(gcf,'CT_anom_dist.png','Resolution',300)

close all

%% Plot distribution of salinity anomalies.

figure;

tmp = cmocean('curl',16);

histogram(anom.anom.SA(:),-2:0.25:2,'FaceColor',tmp(5,:),'FaceAlpha',1);

hold on

plot(mean(anom.anom.SA(:),'omitnan')*ones(2,1),[0 200],'k-','LineWidth',2)
plot((mean(anom.anom.SA(:),'omitnan')+std(anom.anom.SA(:),'omitnan'))*ones(2,1),[0 200],'k--','LineWidth',2)
plot((mean(anom.anom.SA(:),'omitnan')-1*std(anom.anom.SA(:),'omitnan'))*ones(2,1),[0 200],'k--','LineWidth',2)

xlabel('\it{S}\rm_A_{ anom} (g/kg)','FontSize',20); ylabel('Counts','FontSize',20);
xlim([-2 2]);
set(gca,'FontSize',18);
axis square;

clear tmp

%% Save.

cd([folder '/figures'])
saveas(gcf,'SA_anom_dist.fig');
exportgraphics(gcf,'SA_anom_dist.png','Resolution',300)

close all
