%% plot_mdl_sharkCTD.m
% Sub-function for SalmonSharksCTD.m; plot linear regression models for
% conservative temperature and absolute salinity.

%% Plot linear regression model for conservative temperature.

figure;

plot(wod.CTDSRDL.all.CT,shark.wod.CTDSRDL.CT,'.','Color',cmap(end-10,:));

hold on

tmp.o = plot([2 18],[2 18],'k--','LineWidth',2);

hold on

tmp.x = 2:1:18; tmp.x = tmp.x.'; tmp.y = predict(mdl.CT,tmp.x);
tmp.f = plot(tmp.x,tmp.y,'-','LineWidth',2,'Color',cmap(6,:));

hold on

text(11,17,['R^2 = ' num2str(roundn(mdl.CT.Rsquared.Ordinary,-3))],'FontSize',18,'Color',cmap(6,:))

xlabel('Argo {\Theta} ({\circ}C)','FontSize',20); ylabel('Shark {\Theta} ({\circ}C)','FontSize',20);
xlim([2 18]); ylim([2 18]);
xticks([2 6 10 14 18]); yticks([2 6 10 14 18]);
axis square
set(gca,'FontSize',18);

grid on

legend([tmp.f; tmp.o],{['y = ' num2str(round(mdl.CT.Coefficients.Estimate(2),3)) '*x + ' ...
    num2str(round(mdl.CT.Coefficients.Estimate(1),3))]; ...
    '1:1 Line'},'Location','SouthEast');

clear tmp

%% Save.

cd([folder '/figures'])
saveas(gcf,'Argo_vs_Shark_CT_mdl.fig');
exportgraphics(gcf,'Argo_vs_Shark_CT_mdl.png','Resolution',300);

close all

%% Plot linear regression model for absolute salinity.

figure;

plot(wod.CTDSRDL.all.SA,shark.wod.CTDSRDL.SA,'.','Color',cmap(end-10,:));

hold on

tmp.o = plot([31.5 34.5],[31.5 34.5],'k--','LineWidth',2);

hold on

tmp.x = 31.5:0.5:34.5; tmp.x = tmp.x.'; tmp.y = predict(mdl.SA,tmp.x);
tmp.f = plot(tmp.x,tmp.y,'-','LineWidth',2,'Color',cmap(6,:));

hold on

text(33.2,34.3,['R^2 = ' num2str(roundn(mdl.SA.Rsquared.Ordinary,-3))],'FontSize',18,'Color',cmap(6,:))

xlabel('Argo \it{S}\rm_A (g/kg)','FontSize',20); ylabel('Shark \it{S}\rm_A (g/kg)','FontSize',20);
xlim([31.5 34.5]); ylim([31.5 34.5]);
xticks([31.5 32.5 33.5 34.5]); yticks([31.5 32.5 33.5 34.5]);
set(gca,'FontSize',18);
axis square

grid on

legend([tmp.f; tmp.o],{['y = ' num2str(round(mdl.SA.Coefficients.Estimate(2),3)) '*x + ' ...
    num2str(round(mdl.SA.Coefficients.Estimate(1),3))]; ...
    '1:1 Line'},'Location','SouthEast');

clear tmp

%% Save.

cd([folder '/figures'])
saveas(gcf,'Argo_vs_Shark_SA_mdl.fig');
exportgraphics(gcf,'Argo_vs_Shark_SA_mdl.png','Resolution',300);

close all
