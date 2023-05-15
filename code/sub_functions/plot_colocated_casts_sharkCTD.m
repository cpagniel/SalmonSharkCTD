%% plot_colocated_casts_sharkCTD.m
% Sub-function for SalmonSharksCTD.m; plots profiles of co-located WOD and
% CTD-SRDL data.

%% Plot paired CTD-SRDL and Argo conservative temperature profiles.

figure;

tmp.ax1 = subplot(1,2,1);
tmp.argo = plot(wod.CTDSRDL.PFL.CT(:,wod.CTDSRDL.all.indy(1)),wod.CTDSRDL.PFL.z(:,wod.CTDSRDL.all.indy(1)),'-','LineWidth',2,'Color','k');

hold on

for i = 1:2
    dt = day(shark.corr.datetime(wod.CTDSRDL.all.indx(i)) - shark.corr.datetime(1)) + 1;
    tmp.shark = plot(shark.corr.CT(:,wod.CTDSRDL.all.indx(i)),shark.corr.z(:,wod.CTDSRDL.all.indx(i)),'-','LineWidth',2,'Color',cmap(dt,:));

    hold on
end
clear i 
clear dt

xlim([2 18]); ylim([0 40]);
xticks([2 6 10 14 18]);
xlabel('{\Theta} ({\circ}C)','FontSize',20); ylabel('Depth (m)','FontSize',20);
set(gca,'ydir','reverse','FontSize',18);

tmp.ax2 = subplot(1,2,2);
tmp.argo = plot(wod.CTDSRDL.PFL.CT(:,wod.CTDSRDL.all.indy(3)),wod.CTDSRDL.PFL.z(:,wod.CTDSRDL.all.indy(3)),'-','LineWidth',2,'Color','k');

hold on

for i = 3
    dt = day(shark.corr.datetime(wod.CTDSRDL.all.indx(i)) - shark.corr.datetime(1)) + 1;
    tmp.shark = plot(shark.corr.CT(:,wod.CTDSRDL.all.indx(i)),shark.corr.z(:,wod.CTDSRDL.all.indx(i)),'-','LineWidth',2,'Color',cmap(dt,:));

    hold on
end
clear i 
clear dt

xlim([2 18]); ylim([0 250]);
xticks([2 6 10 14 18]);
xlabel('{\Theta} ({\circ}C)','FontSize',20); ylabel('Depth (m)','FontSize',20);
set(gca,'ydir','reverse','FontSize',18)

clear tmp

%% Save.

cd([folder '/figures'])
saveas(gcf,'Argo_vs_Shark_CT_profiles.fig');
exportgraphics(gcf,'Argo_vs_Shark_CT_profiles.png','Resolution',300);

close all

%% Plot paired shark and Argo absolute salinity profiles.

figure;

tmp.ax1 = subplot(1,2,1);
tmp.argo = plot(wod.CTDSRDL.PFL.SA(:,wod.CTDSRDL.all.indy(1)),wod.CTDSRDL.PFL.z(:,wod.CTDSRDL.all.indy(1)),'-','LineWidth',2,'Color','k');

hold on

for i = 1:2
    dt = day(shark.corr.datetime(wod.CTDSRDL.all.indx(i)) - shark.corr.datetime(1)) + 1;
    tmp.shark = plot(shark.corr.SA(:,wod.CTDSRDL.all.indx(i)),shark.corr.z(:,wod.CTDSRDL.all.indx(i)),'-','LineWidth',2,'Color',cmap(dt,:));

    hold on
end
clear i 
clear dt

xlim([31.5 34.5]); ylim([0 40]);
xticks([31.5 32.5 33.5 34.5]); yticks([]);
xlabel('\it{S}\rm_A (g/kg)','FontSize',20); % ylabel('Depth (m)','FontSize',20);
set(gca,'ydir','reverse','FontSize',18);

legend([tmp.argo tmp.shark],'Argo','Shark','Location','southeast')

pos = get(gca,'Position');
pos(2) = pos(2) + 0.05;
set(gca,'Position',pos);

tmp.ax2 = subplot(1,2,2);
tmp.argo = plot(wod.CTDSRDL.PFL.SA(:,wod.CTDSRDL.all.indy(3)),wod.CTDSRDL.PFL.z(:,wod.CTDSRDL.all.indy(3)),'-','LineWidth',2,'Color','k');

hold on

for i = 3
    dt = day(shark.corr.datetime(wod.CTDSRDL.all.indx(i)) - shark.corr.datetime(1)) + 1;
    tmp.shark = plot(shark.corr.SA(:,wod.CTDSRDL.all.indx(i)),shark.corr.z(:,wod.CTDSRDL.all.indx(i)),'-','LineWidth',2,'Color',cmap(dt,:));

    hold on
end
clear i 
clear dt

xlim([31.5 34.5]); ylim([0 250]);
xticks([31.5 32.5 33.5 34.5]); yticks([]);
xlabel('\it{S}\rm_A (g/kg)','FontSize',20); % ylabel('Depth (m)','FontSize',20);
set(gca,'ydir','reverse','FontSize',18);

legend([tmp.argo tmp.shark],'Argo','Shark','Location','southwest')

pos = get(gca,'Position');
pos(2) = pos(2) + 0.05;
set(gca,'Position',pos);

clear tmp
clear pos

%% Save.

cd([folder '/figures'])
saveas(gcf,'Argo_vs_Shark_SA_profiles.fig');
exportgraphics(gcf,'Argo_vs_Shark_SA_profiles.png','Resolution',300);

close all
