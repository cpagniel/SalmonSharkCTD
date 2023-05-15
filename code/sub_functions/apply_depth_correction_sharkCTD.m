%% apply_depth_correction_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; apply zero-offset correction. Plotting
% is commented out.

% The following recreates the zero-offset correction from Luque and Fried
% (2011) (https://doi.org/10.1371/journal.pone.0015850), which is included
% in diveMove R package (https://cran.r-project.org/web/packages/diveMove/).

%% Loop through each unique tag and apply depth correction.

toppID.pat = unique(PAT.raw.TOPPid);
zoc = cell(length(toppID.pat),1);

for i = 1:length(toppID.pat)

    sub = PAT.raw(PAT.raw.TOPPid == toppID.pat(i),:);

    %% Sort PAT data to increase with time and limit to time before popup date.

    [~,ind] = sort(sub.DateTime);
    sub = sub(ind,:);
    clear ind

    %% Remove PAT data when depth values are greater than 2000 m.

    ind = sub.Depth > 2000;
    sub(ind,:) = [];
    clear ind

    %% Remove duplicates.

    [~,ind,~] = unique(sub.DateTime);
    sub = sub(ind,:);
    clear ind

    %% Downsample data to increase processing speed.

    X = 120./seconds((sub.DateTime(2)-sub.DateTime(1))); % downsample to every 2 minutes

    tmp.Depth = downsample(sub.Depth,X);
    tmp.DateTime = downsample(sub.DateTime,X);

    clear X

    %% Adjust K for sampling frequency of the tag.

    KK(1) = seconds(PARAMS.depth.K(1))*(1/seconds(tmp.DateTime(2) - tmp.DateTime(1))); % window length for filter #1 (in minutes)
    KK(2) = seconds(PARAMS.depth.K(2))*(1/seconds(tmp.DateTime(2) - tmp.DateTime(1))); % window length for filter #2 (in days)

    %% Filter #1:

    % Apply a median smoothing step to remove noise, particularly from
    % measurements near the surface surface measurements. Select a small window to
    % avoid eroding the surface signal. For example, if the TDR has a sampling frequency
    % of 1/3 Hz (i.e., one sample every 3 seconds) and a 18 second smoothing window
    % is desired, the window should be K = 6 (i.e., 18 seconds * 1/3 1/seconds)

    zoc{i}.filter_1 = smoothdata(tmp.Depth,'movmedian',KK(1));

    %% Filter #2:

    % Apply a moving quantile filter to correct for drift and level shifts.
    % Select as large a window as possible. If little or negligible noise remains
    % after applying the first filter, a quantile close to the minimum (0.01–0.05)
    % is appropriate. For example, if the TDR has a sampling frequency of 1/3 Hz (i.e.,
    % one sample every 3 seconds) and a 4.5 hour window is desired, the window should
    % be K = 5400 (i.e., 4.5 hours * 60 minutes/hour * 60 seconds/minute * 1/3 1/seconds).
    % We have chosen P = 0.01 quantile.

    % zoc{i}.filter_2 = movquant(zoc{i}.filter_1,P,K(2),1,'omitnan','zeropad');
    if KK(2) > length(tmp.Depth)
        zoc{i}.filter_2 = running_percentile(zoc{i}.filter_1,length(tmp.Depth),PARAMS.depth.P*100);
    else
        zoc{i}.filter_2 = running_percentile(zoc{i}.filter_1,KK(2),PARAMS.depth.P*100);
    end

    clear KK

    %% Reinterpolate output of Filter #2 to match original sampling frequency.

    zoc{i}.filter_3 = interp1(tmp.DateTime,zoc{i}.filter_2,sub.DateTime);
    zoc{i}.filter_3(isnan(zoc{i}.filter_3)) = 0;

    %% Subtract the output of Filter #2 from the original data.

    sub.Depth = sub.Depth - zoc{i}.filter_3;

    %% Append new PAT tag data to previous PAT tag data in table.

    if i == 1
        PAT.DC = sub;
    else
        PAT.DC = [PAT.DC; sub];
    end

    %% Plot depth-corrected timeseries.

%     figure;
% 
%     X = 120./seconds((sub.DateTime(2)-sub.DateTime(1))); % downsample to every 2 minutes
%     f1 = plot(unique(downsample(sub.DateTime,X)),zoc{i}.filter_1,'b-');
% 
%     hold on
% 
%     f2 = plot(sub.DateTime,zoc{i}.filter_3,'r-','LineWidth',2);
% 
%     xlabel('Date'); ylabel('Depth (m)');
%     legend([f1 f2],'Filter #1','Filter #2','Location','best');
% 
%     set(gca,'ydir','reverse');
%     grid on; grid minor;
% 
%     axis tight; ylim([-30 30]);

    %% Clear

    clear X
    clear f1 f2

    clear tmp
    clear sub

end
clear i
clear zoc