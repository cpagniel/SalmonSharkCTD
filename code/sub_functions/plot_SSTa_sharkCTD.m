%% plot_SSTa_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot SST anomaly on each day with
% shark trajectory.

%% Loop through all dates.

for i = 1:length(sst.time)

    %% Create figure and projection.

    figure;
    m_proj('lambert','long',[-150 -125],'lat',[50 60],'rectbox','off');

    %% Plot SST anomaly;

    m_pcolor(sst.lon,sst.lat,squeeze(sst.anom(i,:,:)))
    shading flat;

    cmocean('balance',16);
    h = colorbar('southoutside','FontSize',18);
    ylabel(h,'Sea Surface Temperature Anomaly ({\circ}C)','FontSize',20);
    caxis([-4 4]);

    hold on

    %% Plot land.

    m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

    hold on

    %% Plot ARGOS positions.

    cnt1 = 0;
    for j = 1:length(argos.date)
        if datetime(year(argos.date(j)),month(argos.date(j)),day(argos.date(j)),'TimeZone','UTC') == sst.time(i)
            if argos.qual(j) >= 1
                h1 = m_plot(argos.lon(j),argos.lat(j),'ko','markersize',2,'markerfacecolor','k');
                cnt1 = 1;

                hold on
            end
        end
    end
    clear j

    hold on

    %% Plot shark-collected CTD locations.

    cnt2 = 0;
    for j = 1:length(shark.corr.datetime)
        if datetime(year(shark.corr.datetime(j)),month(shark.corr.datetime(j)),day(shark.corr.datetime(j)),'TimeZone','UTC') == sst.time(i)
            h2 = m_plot(shark.corr.lon(j),shark.corr.lat(j),'ko','MarkerFaceColor','w');
            cnt2 = 1;

            hold on
        end
    end
    clear j

    hold on

    %% Plot grid.

    m_grid('linest','none','tickdir','out','box','fancy','fontsize',16);
    m_northarrow(-149,50.75,1,'type',2,'linewi',2);
    m_ruler([.72 .87],.11,2,'fontsize',12,'ticklength',0.01);

    %% Position axes.

    p = get(gca,'Position');
    h.Position = h.Position + [.05 -.02 -.1 0];
    set(gca,'Position',p);

    %% Add date.

    title(datestr(sst.time(i)),'FontSize',22);

    %% Plot legend.

    if cnt1 == 1 && cnt2 == 1
        legend([h1,h2],'Shark Trajectory','Shark Profiles','Position',[0.6179 0.8128 0.1911 0.0631])
    elseif cnt1 == 1 && cnt2  == 0
        legend(h1,'Shark Trajectory','Position',[0.6179 0.8128 0.1911 0.0631])
    elseif cnt1 == 0 && cnt2 == 1
        legend(h2,'Shark Profiles','Position',[0.6179 0.8128 0.1911 0.0631])
    end

    hold on

    %% Save.

    cd([folder '/figures/SST']);
    saveas(gcf,[num2str(i) '-' datestr(sst.time(i)) '_sst.fig']);
    exportgraphics(gcf,[num2str(i) '-' datestr(sst.time(i)) '_sst.png'],'Resolution',300);

    close all

    %% Clear

    clear h*
    clear cnt*

end

%% Clear

clear i
clear h* ans
clear p