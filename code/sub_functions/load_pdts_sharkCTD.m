%% load_pdts_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load PAT-style Depth-Temperature
% profiles.

%% Load meta with summary hours.

cd([folder '/data/meta/latest_from_Mike']);
meta = readtable('camille_salmonshark_metadata_2023apr7.csv');

%% Load PDTs.

cd([folder '/data/pdt']);
files = dir('*.csv');

old = [];
for i = 1:length(files)
    opts = detectImportOptions(files(i).name);
    opts.DataLines(1) = 2;
    opts.VariableNamesLine = 1;

    new = readtable(files(i).name,opts);
    new = new(:,[1 3:7]);
    new.Properties.VariableNames = {'PDTNumber','DateTime','Depth','MinTemp','MaxTemp','MeanTemp'};

    tmp = ones(height(new),1).*str2double(files(i).name(1:7));
    new = addvars(new,tmp,'Before','PDTNumber');

    pdt = [old; new];

    old = pdt;
    clear *new opts
end
clear i 
clear files
clear tmp
clear old

pdt.Properties.VariableNames{1} = 'toppID';

%% Assign global PDT number.

old_tag = pdt.toppID(1);
old_pdt = pdt.PDTNumber(1);

pdt.GlobalNumber(1) = 1;

cnt = 1;
for i = 2:height(pdt)
    if pdt.toppID(i) == old_tag && pdt.PDTNumber(i) == old_pdt
        pdt.GlobalNumber(i) = cnt;
    else
        cnt = cnt + 1;
        pdt.GlobalNumber(i) = cnt;

        old_tag = pdt.toppID(i);
        old_pdt = pdt.PDTNumber(i);
    end
end
clear i
clear cnt

clear old*

pdt = movevars(pdt, 'GlobalNumber', 'Before', 'DateTime');

%% Remove PDTs with less than 4 points & with temperature values less than 2 deg C.

ind = zeros(max(pdt.GlobalNumber),1);

for i = 1:max(pdt.GlobalNumber)
    if length(pdt.Depth(pdt.GlobalNumber == i)) < 4 || sum(pdt.MeanTemp(pdt.GlobalNumber == i) < 2) ~= 0
        ind(pdt.GlobalNumber == i) = 1;
    end
end
clear i

pdt(ind == 1,:) = [];
clear ind

%% Re Assign global PDT number.

old_tag = pdt.toppID(1);
old_pdt = pdt.PDTNumber(1);

pdt.GlobalNumber(1) = 1;

cnt = 1;
for i = 2:height(pdt)
    if pdt.toppID(i) == old_tag && pdt.PDTNumber(i) == old_pdt
        pdt.GlobalNumber(i) = cnt;
    else
        cnt = cnt + 1;
        pdt.GlobalNumber(i) = cnt;

        old_tag = pdt.toppID(i);
        old_pdt = pdt.PDTNumber(i);
    end
end
clear i
clear cnt

clear old*

%% Remove PDTS less than 24 m and with NaN depths.

[~,ia,~] = unique(pdt.GlobalNumber,'last');
ind = pdt.Depth(ia) >= 24;
pdt = pdt(ismember(pdt.GlobalNumber,pdt.GlobalNumber(ia(ind))),:);
pdt(ismember(pdt.GlobalNumber,pdt.GlobalNumber(isnan(pdt.Depth))),:) = [];

clear ia
clear ind

%% Re Assign global PDT number.

old_tag = pdt.toppID(1);
old_pdt = pdt.PDTNumber(1);

pdt.GlobalNumber(1) = 1;

cnt = 1;
for i = 2:height(pdt)
    if pdt.toppID(i) == old_tag && pdt.PDTNumber(i) == old_pdt
        pdt.GlobalNumber(i) = cnt;
    else
        cnt = cnt + 1;
        pdt.GlobalNumber(i) = cnt;

        old_tag = pdt.toppID(i);
        old_pdt = pdt.PDTNumber(i);
    end
end
clear i
clear cnt

clear old*