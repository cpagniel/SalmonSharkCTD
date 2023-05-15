%% load_recoveredPAT_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load recovered PAT tag timeseries.
% Plotting is commented out.

%% Folder and files.

cd([folder '/data/archival/']);
files = dir('*.csv');

for i = 1:length(files)

%% Load .csv file in a table. Only keep first four columns with Time, Depth, Temperautre and LightLevel.

    tmp = readtable(files(i).name);
    tmp = tmp(:,1:4);

%% Remove rows in table when there are temperature or depth values missing.

    tmp(isnan(table2array(tmp(:,3))),:) = [];
    tmp(isnan(table2array(tmp(:,2))),:) = [];

%% Rename headers and set time zone.

    tmp.Properties.VariableNames = {'DateTime' 'Depth' 'Temperature' 'LightLevel'};
    tmp.DateTime.TimeZone = 'UTC';

%% Add TOPP ID to table.

    TOPPid = str2double(files(i).name(1:7))*ones(height(tmp),1);
    tmp = addvars(tmp,TOPPid,'Before','DateTime');

%% Plot raw depth timeseries.

%     figure;
% 
%     plot(tmp.DateTime,tmp.Depth,'k-');
% 
%     hold on
% 
%     ylimits = ylim;
%     plot([meta_PAT.popdate(meta_PAT.toppID == TOPPid(1)) meta_PAT.popdate(meta_PAT.toppID == TOPPid(1))],[-50 ylimits(2)],'r-','LineWidth',2);
% 
%     set(gca,'ydir','reverse','fontsize',18);
%     title(num2str(TOPPid(1)),'fontsize',22);
%     xlabel('Time','fontsize',20); ylabel('Depth (m)','fontsize',20)
% 
%     clear ylimits

%% Remove data after PAT popup date.

    ind = tmp.DateTime > meta_PAT.pat_popup_date(meta_PAT.toppid == TOPPid(1));
    tmp(ind,:) = [];

    clear ind

%% Append new PAT tag data to previous PAT tag data in table.

    if i == 1
        PAT.raw = tmp;
    else
        PAT.raw = [PAT.raw; tmp];
    end

    clear tmp
    clear TOPPid
end
clear i

%% Clear

clear files
clear meta_PAT