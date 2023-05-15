%% plot_ADT_eddy_gif_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plot daily absolute dynamic topography, 
% eddy contours and shark trajectory.

%% Loop through all dates.

for i = 3:length(sat.time) % Start on August 14, 2015

    %% Create figure and projection.

    figure;
    m_proj('lambert','long',[-150 -125],'lat',[49.7 60],'rectbox','off');

    %%  Plot daily ADT.

    m_pcolor(sat.lon,sat.lat,sat.adt(:,:,i).');
    shading flat;

    cmocean('balance');
    h = colorbar('southoutside','FontSize',18,'Ticks',0.25:0.1:0.75);
    ylabel(h,'Absolute Dynamic Topography (m)','FontSize',20);
    caxis([0.25 0.75]);

    hold on

    %% Plot land.

    m_gshhs_h('patch',[.7 .7 .7],'edgecolor','k');

    hold on

    %% Plot eddies.

    % Anticyclonic
    ind = find(datetime(year(eddies.AC.Date),month(eddies.AC.Date),day(eddies.AC.Date),'TimeZone','UTC') == sat.time(i));
    for j = 1:length(ind)
        m_plot(eddies.AC.EffectiveContourLongitude{ind(j)},eddies.AC.EffectiveContourLatitude{ind(j)},'r-','LineWidth',2);
    end
    clear ind
    clear j

    % Cyclonic
    ind = find(datetime(year(eddies.CC.Date),month(eddies.CC.Date),day(eddies.CC.Date),'TimeZone','UTC') == sat.time(i));
    for j = 1:length(ind)
        m_plot(eddies.CC.EffectiveContourLongitude{ind(j)},eddies.CC.EffectiveContourLatitude{ind(j)},'b-','LineWidth',2);
    end
    clear ind
    clear j

    hold on

    %% Plot ARGOS position.

    for j = 1:length(argos.date)
        if datetime(year(argos.date(j)),month(argos.date(j)),day(argos.date(j)),'TimeZone','UTC') == sat.time(i)
            if argos.qual(j) >= 1
                m_plot(argos.lon(j),argos.lat(j),'ko','markersize',2,'markerfacecolor','k');

                hold on
            end
        end
    end
    clear j

    hold on

    %% Plot shark-collected CTD location.

    for j = 1:length(shark.corr.datetime)
        if datetime(year(shark.corr.datetime(j)),month(shark.corr.datetime(j)),day(shark.corr.datetime(j)),'TimeZone','UTC') == sat.time(i)
            m_plot(shark.corr.lon(j),shark.corr.lat(j),'ko','MarkerFaceColor','w');

            hold on
        end
    end
    clear j

    %% Create grid.

    m_grid('linest','none','tickdir','out','box','fancy','fontsize',16);
    m_northarrow(-149,50.75,1,'type',2,'linewi',2);
    m_ruler([.72 .87],.11,2,'fontsize',14,'ticklength',0.01);

    %% Adjust axes.

    p = get(gca,'Position');
    h.Position = h.Position + [.05 -.01 -.1 0];
    set(gca,'Position',p);

    %% Add date.

    title(datestr(sat.time(i)),'FontSize',22);

    %% Save.

    cd([folder '/figures/gif/']);
    saveas(gcf,[num2str(i-2) '-' datestr(sat.time(i)) '_adt.fig'])
    exportgraphics(gcf,[num2str(i-2) '-' datestr(sat.time(i)) '_adt.png'],'Resolution',300);

    close all

end
clear i

%% Clear

clear ans
clear h
clear p
