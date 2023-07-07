%% Novel CTD fin tag highlights potential of sharks to serve as ocean observing platforms in the Gulf of Alaska
% Pagniello et al. (2023)

% Author: Camille Pagniello (cpagniel@stanford.edu)

% Last Update: 07/06/2023

%% Directory

folder = '/Users/cpagniello/Library/CloudStorage/GoogleDrive-cpagniel@stanford.edu/My Drive/Projects/SalmonSharks';
cd([folder '/code']);

%% Requirements

warning off

% Matlab Functions
    % gsw MATLAB toolbox (http://www.teos-10.org/software.htm)
        % gsw_SA_CT_plot_edit.m
    % hex2rgb (https://www.mathworks.com/matlabcentral/fileexchange/46289-rgb2hex-and-hex2rgb?s_tid=mwa_osa_a)
    % m_map (https://www.eoas.ubc.ca/~rich/map.html)
    % objmap_kelley.m and associated sub functions
    % Climate Data Toolbox (http://www.chadagreene.com/CDT/CDT_Contents.html)

% Data
    % first baroclinic mode gravity and Rossby wave speeds (https://ecjoliver.weebly.com/rossby-radius.html)

% Colormaps
run load_cmap_sharkCTD

%% Materials and Methods

% CTD Post-Processing
run load_CTDSRDL_sharkCTD
run load_argos_sharkCTD
run postprocessing_CTD_sharkCTD
run plot_TSdiagram_sharkCTD

% Objective Mapping
run objmap_sharkCTD
run calc_mld_sharkCTD
run plot_sections_sharkCTD

% Anomalies <-- add MLD to anomaly sections
run bin_CTDSRDL_WOA_sharkCTD
run load_WOA_clims_sharkCTD
run calc_anoms_sharkCTD
run plot_anom_dist_sharkCTD
run objmap_anom_sharkCTD
run plot_anom_sections_sharkCTD

clear anom

% SST Anomaly Data
run load_SSTa_sharkCTD
run plot_SSTa_sharkCTD

clear sst

% SSS Anomaly Data
run load_SSSa_sharkCTD
run plot_SSSa_sharkCTD

clear sss

% Eddies and Other Satellite Oceanographic Data
run load_eddies_sharkCTD
run is_shark_in_eddy_sharkCTD
run plot_eddy_type_sharkCTD
run load_sat_data_sharkCTD
run plot_meanADT_sharkCTD
run plot_meanEKE_sharkCTD

clear eddies
clear sat

% Other Tag Deployments on Salmon Sharks
run load_metaPAT_sharkCTD
run load_recoveredPAT_sharkCTD
run load_SPOT_interpPFL_sharkCTD
run plot_SPOT_interpPFL_map_sharkCTD

% Depth Correction, Dive Detection and Profile Extraction from Recovered
% PAT Tags
run set_PARAMS_sharkCTD
run apply_depth_correction_sharkCTD
run detect_dives_sharkCTD
run plot_dives_sharkCTD
run extract_TD_profiles_sharkCTD
run plot_TD_profiles_sharkCTD
run locate_TD_profiles_sharkCTD
run plot_TD_profiles_map_sharkCTD
run plot_histo_TD_depthrange_sharkCTD

% Profiles of Depth-Temperature (PDTs)
run load_pdts_sharkCTD
run locate_pdts_sharkCTD
run plot_PDT_PAT_map_sharkCTD

% Dive Spacing Resolution
run calc_dive_spacing_CTDSRDL_sharkCTD
run plot_dive_spacing_CTDSRDL_sharkCTD
run calc_dive_spacing_PAT_sharkCTD
run plot_dive_spacing_PAT_sharkCTD

clear oce
clear rossby
clear spacing

% Oceanographic Profiles from the World Ocean Database
run load_WOD_2002_to_2019_sharkCTD
run plot_WOD_2002_to_2019_map_by_platform_sharkCTD
run plot_WOD_2002_to_2019_map_sharkCTD
run plot_diff_WOD_SPOT_interpPFL_map_sharkCTD
run plot_binary_diff_WOD_SPOT_interpPFL_map_sharkCTD
run plot_histo_allPFLs_year_sharkCTD
run plot_histo_allPFLs_month_sharkCTD

clear binned
clear L*

% Argo Comparision
run load_WOD_CTDSRDL_sharkCTD
run compare_CTDSRDL_WOD_sharkCTD
run plot_CTDSRDL_WOD_map_sharkCTD
run plot_mdl_sharkCTD
run plot_colocated_casts_sharkCTD
run plot_colocated_map_sharkCTD

%% Additional Visualizations

run plot_ADT_eddy_gif_sharkCTD % requires eddies, sat, argos and shark structures
