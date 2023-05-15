%% extract_TD_profiles_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; extract temperature-depth profiles
% from recovered PAT tags.

%% Define blank structure.

%% Loop through all recovered PAT tags.

for i = 1:length(toppID.pat)

    sub = PAT.DC(PAT.DC.TOPPid == toppID.pat(i),:);

    %% Define the start and end of profiles based on dives. 
    % All profiles contain one maximum and one minimum.

    pfl.PAT(i).index = [dives(i).index, [dives(i).index(2:end); length(sub.Depth)]];
    pfl.PAT(i).binary = [dives(i).binary, [dives(i).binary(2:end); length(sub.Depth)]];
    pfl.PAT(i).length = (pfl.PAT(i).index(:,2) - pfl.PAT(i).index(:,1)) + 1;

    pfl.PAT(i).start_time = sub.DateTime(pfl.PAT(i).index(:,1));
    pfl.PAT(i).end_time = sub.DateTime(pfl.PAT(i).index(:,2));
    pfl.PAT(i).duration = pfl.PAT(i).end_time - pfl.PAT(i).start_time;

    ind = sum(pfl.PAT(i).binary,2) ~= 1;

    pfl.PAT(i).index(ind,:) = [];
    pfl.PAT(i).binary(ind,:) = [];
    pfl.PAT(i).length(ind) = [];
    pfl.PAT(i).start_time(ind) = [];
    pfl.PAT(i).end_time(ind) = [];
    pfl.PAT(i).duration(ind) = [];

    clear ind

    %% Extract depth and temperature data from tag for each profile. 
    % Also compute maximum and minimum depth as well as speed of profile.

    for j = 1:length(pfl.PAT(i).index)

        pfl.PAT(i).Depth{j} = sub.Depth(pfl.PAT(i).index(j,1):pfl.PAT(i).index(j,2));
        pfl.PAT(i).Temperature{j} = sub.Temperature(pfl.PAT(i).index(j,1):pfl.PAT(i).index(j,2));

        pfl.PAT(i).MaxDepth(j,1) = max(pfl.PAT(i).Depth{j});
        pfl.PAT(i).MinDepth(j,1) = min(pfl.PAT(i).Depth{j});
        pfl.PAT(i).DepthRange(j,1) = pfl.PAT(i).MaxDepth(j,1) - pfl.PAT(i).MinDepth(j,1);

        pfl.PAT(i).Vz(j,1) = pfl.PAT(i).DepthRange(j,1)./seconds(pfl.PAT(i).duration(j,1)); % m/s
    end
    clear j

    clear sub

    %% Remove all profiles that span less than 4 m.
    
    ind = pfl.PAT(i).DepthRange < 4;

    pfl.PAT(i).index(ind,:) = [];
    pfl.PAT(i).binary(ind,:) = [];
    pfl.PAT(i).length(ind) = [];
    pfl.PAT(i).start_time(ind) = [];
    pfl.PAT(i).end_time(ind) = [];
    pfl.PAT(i).duration(ind) = [];

    pfl.PAT(i).Depth(ind) = [];
    pfl.PAT(i).Temperature(ind) = [];
    pfl.PAT(i).MaxDepth(ind) = [];
    pfl.PAT(i).MinDepth(ind) = [];
    pfl.PAT(i).Vz(ind) = [];
    pfl.PAT(i).DepthRange(ind) = [];

    clear ind

    %% Bin temperature data to 1 m, interpolate to 1 m resolution and smooth profiles.

    for j = 1:length(pfl.PAT(i).index)

        % Bin temperature data into 1 m bins
        d_bin = floor(min(pfl.PAT(i).Depth{j})):1:ceil(max(pfl.PAT(i).Depth{j}))+1;
        d_cat = discretize(pfl.PAT(i).Depth{j},d_bin.');
        T = accumarray(d_cat,pfl.PAT(i).Temperature{j},[],@mean);
        pfl.PAT(i).TemperatureBinned{j} = T(T ~= 0); pfl.PAT(i).DepthBinned{j} = d_bin(T ~= 0);

        % Interpolate to 1 m resolution between min and maximum depth
        tmp = NaN(length(0:PARAMS.pfl.d_interp:650),1);
        if min(pfl.PAT(i).DepthBinned{j}) < 0
            tmp(floor((0:PARAMS.pfl.d_interp:max(pfl.PAT(i).DepthBinned{j}))./PARAMS.pfl.d_interp)+1) = gsw_t_interp(pfl.PAT(i).TemperatureBinned{j},pfl.PAT(i).DepthBinned{j},0:PARAMS.pfl.d_interp:max(pfl.PAT(i).DepthBinned{j}));
        else
            tmp(floor((min(pfl.PAT(i).DepthBinned{j}):PARAMS.pfl.d_interp:max(pfl.PAT(i).DepthBinned{j}))./PARAMS.pfl.d_interp)+1) = gsw_t_interp(pfl.PAT(i).TemperatureBinned{j},pfl.PAT(i).DepthBinned{j},min(pfl.PAT(i).DepthBinned{j}):PARAMS.pfl.d_interp:max(pfl.PAT(i).DepthBinned{j}));
        end
        pfl.PAT(i).TemperatureInterp{j}  = tmp;
        pfl.PAT(i).DepthInterp{j} = 0:PARAMS.pfl.d_interp:650;
        clear tmp

        % Smooth profiles
        pfl.PAT(i).TemperatureDetrend{j} = detrend(pfl.PAT(i).TemperatureInterp{j},'omitnan'); % detrend profile
        pfl.PAT(i).TemperatureSmooth{j} = pfl.PAT(i).TemperatureInterp{j} - pfl.PAT(i).TemperatureDetrend{j} + smoothdata(pfl.PAT(i).TemperatureDetrend{j},'movmedian',round(d_bin(end)*0.15));
        pfl.PAT(i).DepthSmooth{j} = pfl.PAT(i).DepthInterp{j}.';

        clear d_bin
        clear d_cat
        clear T
    end
    clear j

end
clear i

%% Clear

clear dives
clear PARAMS
clear PAT