%% sharkCTD_postprocessing.m
% Sub-function of SalmonSharksCTD.m; filters, interpolates and covert to
% conservative temperature and absolute salinity CTD-SRDL data from shark
% fin tag.

%% Create regular grid of 1-m resolution.

shark.interp.p = 0:1:max(shark.raw.p(:));
shark.interp.p = repmat(shark.interp.p.',[1,size(shark.raw.T,2)]);

%% Remove depths shallower than min pressure of profile and deeper than max pressure of profiles.

min_p = min(shark.raw.p); 
max_p = max(shark.raw.p);

for i = 1:length(min_p)
    ind = shark.interp.p(:,i) < min_p(i) | shark.interp.p(:,i) > max_p(i);
    shark.interp.p(ind,i) = NaN;
end
clear i

clear ind
clear min_p

%% Vertically interpolate profiles onto regular grid of 1-m resolution.

shark.interp.S = gsw_tracer_interp(shark.raw.S,shark.raw.p,shark.interp.p);
shark.interp.T = gsw_t_interp(shark.raw.T,shark.raw.p,shark.interp.p);

%% Detrended profiles for filtering.
% Per Dan Kelley: "Filtering a non-detrended profile is a generally a bad idea. 
% There is almost always a zero-offset problem, and also most properties vary 
% dramatically with depth, so detrending is required as well as zero offsetting." 
% (https://dankelley.github.io/r/2014/01/11/smoothing-hydrographic-profiles.html)

for i = 1:size(shark.interp.p,2)
    shark.detrend.S(:,i) = detrend(shark.interp.S(:,i),'omitnan');
    shark.detrend.T(:,i) = detrend(shark.interp.T(:,i),'omitnan');
end
clear i

%% Apply median filter to detrended profiles.

for i = 1:size(shark.interp.p,2)
    shark.interp.S(:,i) = shark.interp.S(:,i) - shark.detrend.S(:,i) + smoothdata(shark.detrend.S(:,i),'movmedian',round(max_p(i)*0.15));
    shark.interp.T(:,i) = shark.interp.T(:,i) - shark.detrend.T(:,i) + smoothdata(shark.detrend.T(:,i),'movmedian',round(max_p(i)*0.15));
end
clear i

%% Convert to conservative temperature, absolute salinity and depth.

shark.corr.SA = gsw_SA_from_SP(shark.interp.S,shark.interp.p,shark.raw.lon,shark.raw.lat);
shark.corr.SA = gsw_stabilise_SA_const_t(shark.corr.SA,shark.interp.T,shark.interp.p); % remove density-inversions

shark.corr.CT = gsw_CT_from_t(shark.corr.SA,shark.interp.T,shark.interp.p);

shark.corr.z = gsw_z_from_p(shark.interp.p,shark.raw.lat)*-1;

% Copy metadata over to corrected profiles.
shark.corr.lat = shark.raw.lat;
shark.corr.lon = shark.raw.lon;
shark.corr.datenum = datenum(shark.raw.datetime);
shark.corr.datetime = shark.raw.datetime;

%% Remove profiles with sharp and localized jumps induced by the removal of density-intervesions.
% Note, profiles with salinities less than 32.5 g/kg below 100 m are omitted.

for i = 1:length(shark.corr.datenum)
    if sum(shark.corr.SA(100:end,i) < 32.5) > 0
        shark.corr.CT(:,i) = NaN;
        shark.corr.SA(:,i) = NaN;
        shark.corr.z(:,i) = NaN;
        shark.corr.lat(i) = NaN;
        shark.corr.lon(i) = NaN;
        shark.corr.datenum(i) = NaN;
        shark.corr.datetime(i) = NaT;
    end
end
clear i

%% Plot corrected conservative temperature and absolute salinity data vs. depth.

figure;

for i = 1:length(shark.corr.datenum)
    dt = day(shark.raw.datetime(i) - shark.raw.datetime(1)) + 1;

    subplot(1,2,1)
    plot(shark.corr.CT(:,i),shark.corr.z(:,i),'-','Color',cmap(dt,:));
    set(gca,'ydir','reverse','FontSize',16);
    xlabel('{\Theta} ({\circ}C)','FontSize',18);
    ylabel('Depth (m)','FontSize',18);
    xlim([2 18]); ylim([0 300]);
    hold on

    subplot(1,2,2)
    plot(shark.corr.SA(:,i),shark.corr.z(:,i),'-','Color',cmap(dt,:));
    set(gca,'ydir','reverse','FontSize',16);
    xlabel('\it{S}\rm_A (g/kg)','FontSize',18);
    % ylabel('Pressure (dbar)','FontSize',18);
    set(gca,'yticklabels',[]);
    xlim([31.5 34.5]); ylim([0 300]);
    hold on
end
clear i

clear dt
clear max_p

%% Save.

cd([folder '/figures'])
saveas(gcf,'CTD_profiles_clean.fig');
exportgraphics(gcf,'CTD_profiles_clean.png','Resolution',300);

close all
