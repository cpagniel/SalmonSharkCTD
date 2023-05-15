%% objmap_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; create objective map of CTD-SRDL data
% along trajectory of shark.

% Requires m_map (https://www.eoas.ubc.ca/~rich/map.html) and
% objmap_kelley.m including functions therein.

%% Compute the distance (in kilometers) between the first profile location (x  = 0 km) and each profile location to calculate along-track distance.

om.range = m_lldist(shark.raw.lon,shark.raw.lat); % km, distance between successive profiles
om.dist = cumsum(om.range); % km

%% Create grid with along-track distance at the 16 cut points that comprise each profile.

om.gdist = repmat([0; om.dist].',size(shark.corr.CT,1),1);

%% Create regular grid in x and z.

om.dx = roundn(median(om.range),1); % km
om.nx = roundn(max(om.dist),1)/om.dx + 1;
om.x = 0:om.dx:roundn(max(om.dist),1); % km

tmp = diff(shark.raw.p);
om.dz = floor(median(tmp(:),'omitnan')); % dBar
om.z = 0:om.dz:roundn(max(abs(shark.raw.p(:))),1);
clear tmp

%% Set measurement error to 10%.

om.err_val_CT = 0.1; 
om.err_val_SA = 0.1; 

%% Objective mapping with length scales set by the autocorrelation.

om.ind = ~isnan(shark.corr.CT);

[om.xCTi, om.zCTi, om.CTi, om.err_mapCTi, om.Lct] = ...
    objmap_kelley(om.gdist(om.ind), abs(shark.corr.z(om.ind)), ...
    shark.corr.CT(om.ind), ...
    om.x, om.z.', ...
    [ ], ...
    om.err_val_CT);

[om.xSAi, om.zSAi, om.SAi, om.err_mapSAi, om.Lsa] = ...
    objmap_kelley(om.gdist(om.ind), abs(shark.corr.z(om.ind)), ...
    shark.corr.SA(om.ind), ...
    om.x, om.z.', ...
    [ ], ...
    om.err_val_SA);

%% Plot error maps for both objectively mapped CT and SA.

figure('Position',[185 358 898 523]);

subplot(2,1,1);
pcolor(om.x,om.z,om.err_mapCTi);
shading flat;

% xlabel('Along-Track Distance (km)','FontSize',18); 
ylabel('Depth (m)','FontSize',18);
title('{\Theta} ({\circ}C)','FontSize',18);

% h = colorbar; ylabel(h,'Error');
cmocean balance;

set(gca,'ydir','reverse','FontSize',16,'xticklabels',[]);
ylim([0 300]);

subplot(2,1,2);
pcolor(om.x,om.z,om.err_mapSAi);
shading flat;

xlabel('Along-Track Distance (km)','FontSize',18); ylabel('Depth (m)','FontSize',18);
title('\it{S}\rm_A (g/kg)','FontSize',18);

pos = get(gca,'Position');

h = colorbar; ylabel(h,'Minimum Mean-Square Error','FontSize',18);
cmocean balance; 

set(gca,'ydir','reverse','FontSize',16);
ylim([0 300]);

set(gca,'Position',pos);
h.Position(4) = 0.82;

clear h
clear pos

%% Save.

cd([folder '/figures']);
saveas(gcf,'ObjMap_Error.fig');
exportgraphics(gcf,'ObjMap_Error.png','Resolution',300);

close all

%% Mask points with error-to-signal variance greater than 0.4.

vis.x = om.xCTi; vis.x(om.err_mapCTi >= 0.4) = NaN;
vis.p = om.zCTi; vis.p(om.err_mapCTi >= 0.4) = NaN;
vis.CT = om.CTi; vis.CT(om.err_mapCTi >= 0.4) = NaN;
vis.SA = om.SAi; vis.SA(om.err_mapCTi >= 0.4) = NaN;

%% Compute potential density of objectively mapped data.

vis.rho = gsw_rho(vis.SA,vis.CT,vis.p);