%% bin_CTDSRDL_WOA_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; bin CTD-SRDL data into standard depth
% (i.e., 5 m bins from 0 to 100 m, 25 m from 100 to 500 m, and 50 m bins 
% below 500 m)levels of the World Ocean Atlas 2018 to compute anomalies.

%% Define standard depth levels.

anom.shark.z = [0:5:100-5 100:25:300];

%% Bin CTD-SRDL data.

[~,~,anom.bins] = histcounts(shark.corr.z,anom.shark.z);
anom.bins = anom.bins + 1;

anom.shark.CT = NaN(length(anom.shark.z)+1,size(shark.corr.CT,2));
anom.shark.SA = NaN(length(anom.shark.z)+1,size(shark.corr.CT,2));

for i = 1:size(shark.corr.CT,2)
    anom.shark.CT(1:max(anom.bins(:,i)),i) = accumarray(anom.bins(:,i),shark.corr.CT(:,i),[],@mean);
    anom.shark.SA(1:max(anom.bins(:,i)),i) = accumarray(anom.bins(:,i),shark.corr.SA(:,i),[],@mean);
end
clear i

anom.shark.CT(1,:) = []; anom.shark.CT(anom.shark.CT == 0) = NaN;
anom.shark.SA(1,:) = []; anom.shark.SA(anom.shark.CT == 0) = NaN;



