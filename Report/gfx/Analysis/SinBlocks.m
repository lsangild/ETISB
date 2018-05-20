t0 = 0:0.1:(2*pi);
t = [t0, t0 + 2*pi, t0(1:26) + 4*pi];

%Figure
figure
% Block lines
line([2*pi, 2*pi], [-1, 1], 'Color', 'green', 'LineWidth', 2);
line([4*pi, 4*pi], [-1, 1], 'Color', 'green', 'LineWidth', 2);
hold on
plot(t, sin(t), 'o');
% Phase arrow
annotation('textarrow', [0.75, 0.9], [0.8, 0.77], 'String', 'Phase shift', 'FontSize', 18);
% Period arrows
annotation('textarrow', [0.68, 0.77], [0.2, 0.23], 'String', 'Periods', 'FontSize', 18);
annotation('arrow', [0.57, 0.46], [0.2, 0.23]);
% Block arrow
annotation('textarrow', [0.55, 0.9], [0.6, 0.5], 'String', 'Block', 'FontSize', 18);
annotation('arrow', [0.47, 0.13], [0.6, 0.5]);

% Block arrow

grid on
xlim([0, 2.4*2*pi])
%saveas(gcf, 'SinBlocks.pdf');