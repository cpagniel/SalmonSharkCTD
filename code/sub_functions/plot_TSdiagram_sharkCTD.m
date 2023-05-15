%% plot_TSdiagram_sharkCTD.m
% Sub-function of SalmonSharksCTD.m; plots temperature-salinity diagram.

% Requires gsw gsw MATLAB toolbox (http://www.teos-10.org/software.htm) and
% gsw_SA_CT_plot_edit.m.

%% Plot TS diagram.

figure('Position',[-989 -36 614 523]);

gsw_SA_CT_plot_edit(shark.corr.SA,shark.corr.CT,10.1325,23:0.5:28,'',shark.corr.datenum,cmap);

hold on

PSUW = plot([32.6 33.6 33.6 32.6 32.6],[3 3 15 15 3],'k-','LineWidth',2); % Pacific Subarctic Upper Water (PSUW) (3.0–15.0 C, 32.6–33.6%) (Emery, 2003)
PSUW_t = text(33.25,3.35,'PSUW','FontSize',16);
PSIW = plot([33.8 34.3 34.3 33.8 33.8],[5 5 12 12 5],'k--','LineWidth',2); % Pacific Subarctic Intermediate Water (PSIW) (5.0–12.0 C, 33.8–34.3%)  (Emery, 2003)
PSIW_t = text(34,5.35,'PSIW','FontSize',16);

xlim([31.5 34.5]); ylim([2 18]);

%% Save.

cd([folder '/figures']);
saveas(gcf,'TS_Diagram.fig');
exportgraphics(gcf,'TS_Diagram.png','Resolution',300);

close all

%% Clear

clear PS*
