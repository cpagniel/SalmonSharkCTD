%% plot_TD_profiles_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot temperature-depth profiles
% from recovered PAT tags.

%% Define blank structure.

plt = struct([]);

%% Loop through all recovered PAT tags.

for i = 1:length(toppID.pat)

    %% Create matrices of temperature and depth for plotting.

    maxEl = max(arrayfun(@(x) numel(cell2mat(x)),pfl.PAT(i).Temperature)); % Maximum Number of Points

    plt(i).Temperature = cell2mat(arrayfun(@(x) ...
        [cell2mat(x); NaN(maxEl-numel(cell2mat(x)),1)],pfl.PAT(i).Temperature,...
        'uni',0));

    plt(i).Depth = cell2mat(arrayfun(@(x) ...
        [cell2mat(x); NaN(maxEl-numel(cell2mat(x)),1)],pfl.PAT(i).Depth,...
        'uni',0));

    clear maxEl

    %% Plot profiles who span more than 50 m.

    figure;

    tmp.Temperature = plt(i).Temperature; tmp.Depth= plt(i).Depth;
    tmp.Temperature(:,pfl.PAT(i).DepthRange < 50) = []; tmp.Depth(:,pfl.PAT(i).DepthRange < 50) = [];

    plot(tmp.Temperature,tmp.Depth,'k-')

    hold on

    scatter(tmp.Temperature(:),tmp.Depth(:),5,tmp.Temperature(:),'filled');

    cmocean thermal
    h = colorbar; ylabel(h,'Temperature (^oC)');
    caxis([0 20]);
    clear h

    set(gca,'ydir','reverse','fontsize',18);
    title(num2str(toppID.pat(i)),'fontsize',22);
    xlabel('Temperature (^oC)','fontsize',20); ylabel('Depth (m)','fontsize',20)

    xlim([0 20]); ylim([0 700]);
    grid on; grid minor;
    axis square;

    %% Save.

    cd([folder '/figures/profiles']);
    saveas(gcf,[num2str(toppID.pat(i)) '_profiles.fig']);
    exportgraphics(gcf,[num2str(toppID.pat(i)) '_profiles.png'],'Resolution',300);

    close all

    %% Clear

    clear tmp

end
clear i

%% Clear

clear plt