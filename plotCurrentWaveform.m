%% 开始绘制电流波形
function [fig,out_ps,out_mm] = plotCurrentWaveform(in_ps, in_mm)
    fig=figure;
    set(fig,'Units',in_ps.CurrentFigParams.Units,'position', ...
        [3 3 in_ps.CurrentFigParams.Width in_ps.CurrentFigParams.Height],'Resize',0);
    in_ps.CurrentFigParams.InnerPostion=get(fig, 'Position');
    in_ps.CurrentFigParams.OuterPostion=get(fig, 'OuterPosition');
    ax=axes('position',[0.11 0.22 0.85 0.75]);
    in_mm.DataName=fieldnames(in_mm.Data)';
    for i=1:5
        plot(ax,in_mm.Data.(in_mm.DataName{1})([in_ps.Current.StartPoint:in_ps.Current.EndPoint],1), ...
            in_mm.Data.(in_mm.DataName{3+i})([in_ps.Current.StartPoint:in_ps.Current.EndPoint],1), ...
            'color',in_ps.CurrentFigParams.Color(i),...
            'LineWidth',in_ps.CurrentFigParams.LineWidth);
        in_mm.Maxcurrent(i)=max(in_mm.Data.(in_mm.DataName{3+i})([in_ps.Current.StartPoint:in_ps.Current.EndPoint],1));
        hold on
    end
    set(ax,'FontName','Times New Roman', ...
        'FontSize',in_ps.CurrentFigParams.FontSize, ...
        'FontWeight','bold', ...
        'GridLineStyle','--', ...
        'LineWidth',0.9, ...
        'GridAlpha',0.2);
    set(ax,'Xlim',[in_ps.Current.StartTime,in_ps.Current.StartTime+...
        round(max(in_mm.Data.Timebase),1)*in_ps.Current.Length]);
    set(ax,'Ylim',[-in_ps.CurrentFigParams.YZoomin*max(in_mm.Maxcurrent), ...
                    in_ps.CurrentFigParams.YZoomin*max(in_mm.Maxcurrent)]);
    xticklabels(ax,{'0','5','10','15','20'});
    set(ax,'XGrid','on');
    set(ax,'YGrid','on');
    xlabel(ax,'Time(ms)', ...
        'Units','normalized', ...
        'Position',[0.5 -0.2], ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'FontWeight','bold',...
        'FontSize',in_ps.CurrentFigParams.FontSize);
    ylabel(ax,'Current(A)', ...
        'Units','normalized', ...
        'Position',[-0.10 0.5], ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'FontWeight','bold',...
        'FontSize',in_ps.CurrentFigParams.FontSize);
    leg1=legend(ax,'\boldmath{$i_a$}','\boldmath{$i_b$}','\boldmath{$i_c$}', ...
        '\boldmath{$i_d$}','\boldmath{$i_e$}', ...
        'Interpreter','latex', ...
        'Location','best', ...
        'AutoUpdate','off', ...
        'FontName','Times New Roman', ...
        'FontSize',8, ...
        'Orientation','horizontal', ...
        'Box','off');
    leg1.ItemTokenSize=[10,10];
    out_ps=in_ps;
    out_mm=in_mm;
end