%% plot_eddy_type_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot eddy type along-track distance.

%% Plot eddy type along-track distance.

figure('Position',[98 423 1181 35]);

tmp.type = shark.eddy.type; tmp.type(tmp.type == 1) = 999; tmp.type(isnan(tmp.type)) = 9999;
tmp.ind = ischange(tmp.type).'; tmp.ind = sort([0; find(tmp.ind)-1; length(tmp.ind)]);
tmp.dist = [0; om.dist];
tmp.type(tmp.type == 999) = 1; tmp.type(tmp.type == 9999) = 2;

cmap2 = [0 0 1; 1 0 0; 1 1 1]; % red = anticyclonic, blue = cyclonic, white = none

for i = 1:length(tmp.ind)-1
    if tmp.type(tmp.ind(i)+1) ~= 2
        m(i) = patch([tmp.dist(tmp.ind(i)+1) tmp.dist(tmp.ind(i)+1) tmp.dist(tmp.ind(i+1)) tmp.dist(tmp.ind(i+1)) tmp.dist(tmp.ind(i)+1)],...
            [0 -20 -20 0 0],cmap2(tmp.type(tmp.ind(i)+1)+1,:),'EdgeColor','none');
    end
end
clear i

xlim([0 1250]);
set(gca,'LineWidth',1,'XTickLabels',[],'YTickLabels',[],'XTick',[],'YTick',[]);

colorbar;

box on

%% Save.

cd([folder '/figures']);
saveas(gcf,'eddy_type.fig');
exportgraphics(gcf,'eddy_type.png','Resolution',300);

%% Add legend

set(gcf,'Position',[98 375 1181 83])
legend([m(1),m(3)],'ACE','CE','westoutside','FontSize',18)

%% Save.

cd([folder '/figures']);
saveas(gcf,'eddy_type_legend.fig');
exportgraphics(gcf,'eddy_type_legend.png','Resolution',300);

close all

%% Clear

clear cmap2
clear m
clear tmp