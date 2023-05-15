%% compare_CTDSRDL_WOD_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; compare spatially (± 0.75 deg latitude and longitude) 
% and temporally (± 1 day) co-located casts from CTD-SRDL and WOD.

%% Find spatially and temporally co-located casts.

wod.CTDSRDL.all.time = [wod.CTDSRDL.CTD.time; wod.CTDSRDL.PFL.time];
wod.CTDSRDL.all.lon = [wod.CTDSRDL.CTD.lon; wod.CTDSRDL.PFL.lon];
wod.CTDSRDL.all.lat = [wod.CTDSRDL.CTD.lat; wod.CTDSRDL.PFL.lat];

dlon = NaN(length(shark.corr.lon),length(wod.CTDSRDL.all.lon));
for i = 1:length(shark.corr.lon)
    for j = 1:length(wod.CTDSRDL.all.lon)
        dlon(i,j) = abs(wod.CTDSRDL.all.lon(j)-shark.corr.lon(i));
    end
end
clear i j

dlat = NaN(length(shark.corr.lon),length(wod.CTDSRDL.all.lon));
for i = 1:length(shark.corr.lon)
    for j = 1:length(wod.CTDSRDL.all.lon)
        dlat(i,j) = abs(wod.CTDSRDL.all.lat(j)-shark.corr.lat(i));
    end
end
clear i j

shark.corr.datetime.TimeZone = 'America/Los_Angeles';
dt = NaN(length(shark.corr.lon),length(wod.CTDSRDL.all.lon));
for i = 1:length(shark.corr.lon)
    for j = 1:length(wod.CTDSRDL.all.lon)
        dt(i,j) = abs(days(wod.CTDSRDL.all.time(j) - shark.corr.datetime(i)));
    end
end
clear i j

wod.CTDSRDL.all.ind = dlon <= 0.75 & dlat <= 0.75 & dt <= 1;
[wod.CTDSRDL.all.indx,wod.CTDSRDL.all.indy] = ind2sub(size(wod.CTDSRDL.all.ind),find(wod.CTDSRDL.all.ind == 1));
wod.CTDSRDL.all.indy = wod.CTDSRDL.all.indy-7; % since CTD & PFL are combined, subtract first 7 because they are CTD to get PFL number

clear d*

%% Fit linear regression models to both CT and SA data (SharkData ~ WODData).

shark.wod.CTDSRDL.CT = shark.corr.CT(:,wod.CTDSRDL.all.indx);
shark.wod.CTDSRDL.SA = shark.corr.SA(:,wod.CTDSRDL.all.indx);

wod.CTDSRDL.all.CT = wod.CTDSRDL.PFL.CT(1:length(shark.corr.CT),wod.CTDSRDL.all.indy);
wod.CTDSRDL.all.SA = wod.CTDSRDL.PFL.SA(1:length(shark.corr.SA),wod.CTDSRDL.all.indy);

mdl.CT = fitlm(wod.CTDSRDL.all.CT(:),shark.wod.CTDSRDL.CT(:));
mdl.SA = fitlm(wod.CTDSRDL.all.SA(:),shark.wod.CTDSRDL.SA(:));

%% Compute model mean residuals and standard deviation.

mdl.CT_mean_residuals = mean(abs(mdl.CT.Residuals.Raw),'omitnan');
mdl.SA_mean_residuals = mean(abs(mdl.SA.Residuals.Raw),'omitnan');

mdl.CT_std_residuals = std(abs(mdl.CT.Residuals.Raw),'omitnan');
mdl.SA_std_residuals = std(abs(mdl.SA.Residuals.Raw),'omitnan');
