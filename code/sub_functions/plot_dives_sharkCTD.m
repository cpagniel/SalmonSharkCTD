%% plot_dives_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot depth timeseries and start and end of dives.

%% Loop through TOPP IDs.

for i = 1:length(toppID.pat)

    figure;

    plot(PAT.DC.DateTime(PAT.DC.TOPPid == toppID.pat(i)),PAT.DC.Depth(PAT.DC.TOPPid == toppID.pat(i)),'k-')

    hold on

    plot(dives(i).time(dives(i).binary == 1),dives(i).depth(dives(i).binary == 1),'rv')
    plot(dives(i).time(dives(i).binary == 0),dives(i).depth(dives(i).binary == 0),'b^')

    set(gca,'ydir','reverse','fontsize',18);
    title(num2str(toppID.pat(i)),'fontsize',22);
    xlabel('Time','fontsize',20); ylabel('Depth (m)','fontsize',20)

    %% Save.

    cd([folder '/figures/dives']);
    saveas(gcf,[num2str(toppID.pat(i)) '_dives.fig']);
    exportgraphics(gcf,[num2str(toppID.pat(i)) '_dives.png'],'Resolution',300);

    close all

end
clear i