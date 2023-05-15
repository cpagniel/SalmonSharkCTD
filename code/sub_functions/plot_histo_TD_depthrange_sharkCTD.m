%% plot_histo_TD_depthrange_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot histogram of depth ranges for 
% temperature-depth profiles from recovered tags in the Gulf of Alaska.

%% Only keep profiles within the Gulf of Alaska.

dr = vertcat(pfl.PAT.DepthRange);
lon = [pfl.PAT.Longitude].'; lat = [pfl.PAT.Latitude].';

ind_lon = lon <= -125 & lon >= -150; ind_lat = lat >= 50 & lat <= 60;
ind = ind_lon + ind_lat == 2;

%% Plot histogram.

figure;

histogram(dr(ind),[0 10 25 50:50:400]);

set(gca,'FontSize',18);
xlabel('Maximum - Minimum Depth (m)','FontSize',20);
ylabel('Number of Profiles','FontSize',20)

xlim([0 400]);

%% Save.

cd([folder '/figures']);
saveas(gcf,'histo_TD_depthrange.fig');
exportgraphics(gcf,'histo_TD_depthrange.png','Resolution',300);

close all

%% Clear

clear dr
clear ind*
clear lat
clear lon