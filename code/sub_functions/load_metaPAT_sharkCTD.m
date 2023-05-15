%% load_metaPAT_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; load metadata for PAT tags deployed on
% salmon sharks.

%% Load metadata.

cd([folder '/data/meta/latest_from_Mike/']);
meta_PAT = readtable('camille_salmonshark_metadata_2023apr7.csv');
meta_PAT.pat_popup_date.TimeZone = 'UTC';