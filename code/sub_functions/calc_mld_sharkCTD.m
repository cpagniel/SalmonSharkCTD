%% calc_mld_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; calculates mixed layer depth.

% Requires Climate Data Toolbox (http://www.chadagreene.com/CDT/CDT_Contents.html)

%% Calculate mixed layer depth using threshold definition from Boyer Montégut et al (2004).
% Δ_ρ = 0.03 kg/m3 greater than the density at 10 m depth

oce.mld = NaN(size(vis.p,2),3);
for i = 1:size(vis.p,2)
    ind = ~isnan(vis.p(:,i));
    if sum(ind) ~= 0
        oce.mld(i,:) = mld(vis.p(ind,i), vis.CT(ind,i), vis.SA(ind,i), 'metric', 'threshold', ...
            'tthresh', 0.02, 'dthresh', 0.03); % m
    end
end
clear i 

clear ind

%% Estimate MLD for each profile from the objectively mapped data. 
% This is to compute R_d_MLD.

tmp.x = om.x(:); tmp.x = meshgrid(tmp.x,1);
tmp.mld = oce.mld(:,1);

ind = ~isnan(tmp.mld);

rossby.F2 = griddedInterpolant(tmp.x(ind).',tmp.mld(ind));
rossby.mld = rossby.F2([0; om.dist]);

clear tmp ind