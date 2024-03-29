%% load_cmap_sharkCTD.m
% Sub-function for SalmonSharksCTD.m; loads colormaps for analyses.

% Requires hex2rgb.m (https://www.mathworks.com/matlabcentral/fileexchange/46289-rgb2hex-and-hex2rgb?s_tid=mwa_osa_a)

%% Create colormap.

cmap = ['#dc5e8b';...
    '#902445';...
    '#d45e75';...
    '#dd5f68';...
    '#972d36';...
    '#da504c';...
    '#d97a61';...
    '#86321a';...
    '#b64b22';...
    '#df7d52';...
    '#c27c31';...
    '#a87a3d';...
    '#d1952d';...
    '#dab528';...
    '#b8a044';...
    '#adae5f';...
    '#96b23d';...
    '#4a7326';...
    '#6fb95c';...
    '#5cc47b';...
    '#48b98f';...
    '#36dee6';...
    '#7095dc';...
    '#5488e3';...
    '#4157a1';...
    '#847deb';...
    '#605bc2';...
    '#3c2771';...
    '#5b3593';...
    '#9260ba';...
    '#835a9d';...
    '#cc96e4';...
    '#d57fe0';...
    '#a252a4';...
    '#732576'];

cmap = hex2rgb(cmap);