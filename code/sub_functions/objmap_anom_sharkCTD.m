%% objmap_anom_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; objectively map anomalies to match 
% conservative temperature and salinity sections. 

%% Compute horizontal and vertical grids for objective mapping.

anom.om.gdist = repmat([0; om.dist].',[length(anom.shark.z) 1]);
anom.om.shark.z = repmat(anom.shark.z.',[1 length(shark.corr.lon)]);

%% Objectively map anomaly data.

anom.om.ind = ~isnan(anom.anom.CT);

[anom.om.xCTi, anom.om.zCTi, anom.om.CTi, anom.om.err_mapCTi, anom.om.Lct] = ...
    objmap_kelley(anom.om.gdist(anom.om.ind), abs(anom.om.shark.z(anom.om.ind)), ...
    anom.anom.CT(anom.om.ind), ...
    om.x, om.z.', ...
    [ ], ...
    om.err_val_CT);

anom.om.ind = ~isnan(anom.anom.SA);

[anom.om.xSAi, anom.om.zSAi, anom.om.SAi, anom.om.err_mapSAi, anom.om.Lsa] = ...
    objmap_kelley(anom.om.gdist(anom.om.ind), abs(anom.om.shark.z(anom.om.ind)), ...
    anom.anom.SA(anom.om.ind), ...
    om.x, om.z.', ...
    [ ], ...
    om.err_val_SA);

%% Use error map from CTD-SRDL data such that section match.

anom.vis.x = anom.om.xCTi; anom.vis.x(om.err_mapCTi >= 0.4) = NaN;
anom.vis.p = anom.om.zCTi; anom.vis.p(om.err_mapCTi >= 0.4) = NaN;
anom.vis.CT = anom.om.CTi; anom.vis.CT(om.err_mapCTi >= 0.4) = NaN;
anom.vis.SA = anom.om.SAi; anom.vis.SA(om.err_mapCTi >= 0.4) = NaN;