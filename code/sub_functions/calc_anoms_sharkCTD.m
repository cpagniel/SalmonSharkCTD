%% calc_anoms_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; calculate temperature and salinity
% anomalies as well as descriptive statistics of distributions.

%% Find index of nearest (in both space and time) match in climatology to each shark-collected profile based on distance.

anom.shark.clim_ind = NaN(length(shark.corr.lon),1);
for i = 1:length(shark.corr.lon)
    if ~isnan(shark.corr.lat(i))
        [~,anom.shark.clim_ind(i)] = min(distance(shark.corr.lat(i),shark.corr.lon(i),...
            anom.clim.T.August(:,1),anom.clim.T.August(:,2)));
    end
end
clear i

%% Define month of shark-collected profile.

anom.shark.month = month(shark.corr.datetime);

%% Compuate anomalies: Θ_anom = Θ_shark - Θ_climatology). 
% Note, temperature and salinity climatologies need to be converted 
% to conservative temperature and absolute salinity.

anom.anom.CT = NaN(length(anom.shark.z),size(shark.corr.CT,2));
anom.anom.SA = NaN(length(anom.shark.z),size(shark.corr.CT,2));

for i = 1:length(anom.shark.month)
    if anom.shark.month(i) == 8 % August
        tmp.SA = gsw_SA_from_SP(anom.clim.S.August(anom.shark.clim_ind(i),3:end).',...
            anom.shark.z.',...
            anom.clim.S.August(anom.shark.clim_ind(i),2),...
            anom.clim.S.August(anom.shark.clim_ind(i),1));
        tmp.CT = gsw_CT_from_t(tmp.SA,...
            anom.clim.T.August(anom.shark.clim_ind(i),3:end).',...
            anom.shark.z.');

        anom.anom.SA(:,i) = anom.shark.SA(:,i) - tmp.SA;
        anom.anom.CT(:,i) = anom.shark.CT(:,i) - tmp.CT;

        clear tmp
    elseif anom.shark.month(i) == 9 % September
        tmp.SA = gsw_SA_from_SP(anom.clim.S.September(anom.shark.clim_ind(i),3:end).',...
            anom.shark.z.',...
            anom.clim.S.September(anom.shark.clim_ind(i),2),...
            anom.clim.S.September(anom.shark.clim_ind(i),1));
        tmp.CT = gsw_CT_from_t(tmp.SA,...
            anom.clim.T.September(anom.shark.clim_ind(i),3:end).',...
            anom.shark.z.');

        anom.anom.SA(:,i) = anom.shark.SA(:,i) - tmp.SA;
        anom.anom.CT(:,i) = anom.shark.CT(:,i) - tmp.CT;

        clear tmp
    end
end
clear i

%% Remove outliers.
% outliers are more than ± 4 standard deviations away from the overall mean

tmp.CT.mean = mean(anom.anom.CT(:),'omitnan');
tmp.CT.std = std(anom.anom.CT(:),'omitnan');

tmp.SA.mean = mean(anom.anom.SA(:),'omitnan');
tmp.SA.std = std(anom.anom.SA(:),'omitnan');

anom.anom.CT(abs(anom.anom.CT) >= tmp.CT.mean + tmp.CT.std*4) = NaN;
anom.anom.SA(abs(anom.anom.SA) >= tmp.SA.mean + tmp.SA.std*4) = NaN;

clear tmp

%% Compute descriptive statistics of distributions.

anom.stats.CT_mean = mean(anom.anom.CT(:),'omitnan');
anom.stats.CT_std = std(anom.anom.CT(:),'omitnan');
anom.stats.CT_skew = skewness(anom.anom.CT(:));
anom.stats.CT_kurt = kurtosis(anom.anom.CT(:));
anom.stats.CT_min = min(anom.anom.CT(:));
anom.stats.CT_max = max(anom.anom.CT(:));

anom.stats.SA_mean = mean(anom.anom.SA(:),'omitnan');
anom.stats.SA_std = std(anom.anom.SA(:),'omitnan');
anom.stats.SA_skew = skewness(anom.anom.SA(:));
anom.stats.SA_kurt = kurtosis(anom.anom.SA(:));
anom.stats.SA_min = min(anom.anom.SA(:));
anom.stats.SA_max = max(anom.anom.SA(:));
