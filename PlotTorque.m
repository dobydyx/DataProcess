function fig=PlotTorque(in_ps, in_mm,Given_torque)
    fig=figure;
    set(fig,'Units',in_ps.TorqueFigParams.Units,'position', ...
        [3 3 in_ps.TorqueFigParams.Width in_ps.TorqueFigParams.Height],'Resize',1);
    in_ps.CurrentFigParams.InnerPostion=get(fig, 'Position');
    in_ps.CurrentFigParams.OuterPostion=get(fig, 'OuterPosition');
    ax=axes('position',[0.11 0.22 0.85 0.75]);
    in_mm.DataName=fieldnames(in_mm.Data)';
%  
%     X = 2*pi/5;
%     
%     T_Martix=0.4*[1,cos(X),cos(2*X),cos(3*X),cos(4*X);
%                   0,sin(X),sin(2*X),sin(3*X),sin(4*X); 
%                   1,cos(3*X),cos(3*2*X),cos(3*3*X),cos(3*4*X); 
%                   0,sin(3*X),sin(3*2*X),sin(3*3*X),sin(3*4*X);
%                   0.5,0.5,0.5,0.5,0.5];
% 
%     for i=1:length(in_mm.Data.(in_mm.DataName{1}))
%         ElecTheta(i)=in_mm.Data.(in_mm.DataName{2})(i)/3*4095/500;
%         if ElecTheta(i)>2*pi
%             ElecTheta(i)=2*pi;
%         elseif ElecTheta(i)<0
%             ElecTheta(i)=0;
%         end
%     end
% 
% % 假设 dataArray 是你的原始数据数组
% dataArray = ElecTheta; % ...你的原始数据...
% 
% % 初始化一个数组来存储周期跳变点的索引
% jumpIndices = [];
% 
% % 设置一个阈值来识别跳变点
% threshold = 0.4;
% 
% % 找出所有的跳变点
% for k = 2:length(dataArray)
%     if dataArray(k) < dataArray(k-1) - threshold
%         % 如果当前点比前一个点小了0.4（或阈值）以上，记录它
%         jumpIndices = [jumpIndices, k];
%     end
% end
% 
% % 使用找到的跳变点重建锯齿波
% rebuiltWave = zeros(size(dataArray));
% for i = 1:length(jumpIndices)
%     if i == 1
%         % 第一个周期从数组的开始到第一个跳变点
%         periodLength = jumpIndices(i) - 1;
%     else
%         % 后续周期从上一个跳变点到当前跳变点
%         periodLength = jumpIndices(i) - jumpIndices(i-1);
%     end
%     
%     % 计算当前周期内每个点的值
%     increment = (2*pi) / periodLength;
%     for j = 1:periodLength
%         if i == 1
%             % 第一个周期从0开始
%             rebuiltWave(j) = increment * (j - 1);
%         else
%             % 后续周期从上一个周期的最后一个点开始
%             rebuiltWave(jumpIndices(i-1) + j - 1) = increment * (j - 1);
%         end
%     end
% end
% 
% % 处理最后一个周期，如果存在的话
% if jumpIndices(end) < length(dataArray)
%     lastPeriodLength = length(dataArray) - jumpIndices(end);
%     increment = dataArray(length(dataArray)) / lastPeriodLength;
%     for j = 1:lastPeriodLength
%         rebuiltWave(jumpIndices(end) + j - 1) = increment * (j - 1);
%     end
% end
% 
% % 初始化混合波
% MixedWave = dataArray;
% 
% % 在跳变点前后使用 rebuiltWave 的数据
% for idx = jumpIndices
%     startIdx = max(1, idx - 10);
%     endIdx = min(length(dataArray), idx + 20);
%     MixedWave(startIdx:endIdx) = rebuiltWave(startIdx:endIdx);
% end
% 
% % MixedWave 现在包含了重建和原始数据的混合
% 
% 
%     for i=1:length(in_mm.Data.(in_mm.DataName{1}))
%         ialphabeta=T_Martix*[in_mm.Data.(in_mm.DataName{5})(i);in_mm.Data.(in_mm.DataName{6})(i);...
%                 in_mm.Data.(in_mm.DataName{7})(i);in_mm.Data.(in_mm.DataName{8})(i);in_mm.Data.(in_mm.DataName{9})(i)];
%         ialpha1(i)=ialphabeta(1,1);
%         ibeta1(i)=ialphabeta(2,1);
%         ialpha3(i)=ialphabeta(3,1);
%         ibeta3(i)=ialphabeta(4,1);
%         idq=[cos(MixedWave(i)),sin(MixedWave(i));-sin(MixedWave(i)),cos(MixedWave(i))]*[ialpha1(i);ibeta1(i)];
%         id(i)=idq(1,1);
%         iq(i)=idq(2,1);
% %         Te(i)=2.5*31*0.0248*iq(i);
%     end

    plot(ax,in_mm.Data.(in_mm.DataName{1})([in_ps.Torque.StartPoint:1:in_ps.Torque.EndPoint],1), ...
            in_mm.Data.(in_mm.DataName{2})([in_ps.Torque.StartPoint:1:in_ps.Torque.EndPoint],1)*2, ...
            'color',in_ps.TorqueFigParams.Color(1),...
            'LineWidth',in_ps.TorqueFigParams.LineWidth);
%     hold on
%     plot(ax,in_mm.Data.(in_mm.DataName{1})([in_ps.Current.StartPoint:1:in_ps.Current.EndPoint],1), ...
%             id([in_ps.Current.StartPoint:1:in_ps.Current.EndPoint]), ...
%             'color',in_ps.TorqueFigParams.Color(2),...
%             'LineWidth',in_ps.TorqueFigParams.LineWidth);
 
% Start_Point=floor(start_TIME/(Tmin))+1;
% End_Point=floor(END_TIME/Tmin);
% h=figure;
% set(h,'Units','centimeter','position',[0 0 8.8 3.52]);
% ax1=axes('position',[0.1 0.22 0.8 0.75]);
ripple1=std(in_mm.Data.(in_mm.DataName{2})([in_ps.Torque.StartPoint:1:in_ps.Torque.EndPoint],1))/mean(in_mm.Data.(in_mm.DataName{2})([in_ps.Torque.StartPoint:1:in_ps.Torque.EndPoint],1))*100;
% ripple1=std(MotorTorque((Start_Point:1:End_Point),:))./7.5*100;
Tripple_result_str=strcat('\boldmath{$T_{ripple}=',num2str(roundn(ripple1,-2)),'\%$}');

% plot(ax1,MotorCurrent.time((Start_Point:1:End_Point),:),MotorTorque((Start_Point:1:End_Point),:), ...
%     'LineWidth',1,'Color','#CD1818');
yline(ax,Given_torque,'-.b','LineWidth',2,'Color',in_ps.TorqueFigParams.Color(2));
% leg=legend(ax1,'\boldmath{$T_L$}','\boldmath{$T_{L\_ref}$}', ...
%     'Interpreter','latex', ...
%     'Location','southeast', ...
%     'AutoUpdate','off', ...
%     'FontName','Times New Roman');
% leg.ItemTokenSize=[10,10];
    set(ax,'FontName','Times New Roman', ...
        'FontSize',in_ps.TorqueFigParams.FontSize, ...
        'FontWeight','bold', ...
        'GridLineStyle','--', ...
        'LineWidth',0.9, ...
        'GridAlpha',0.2);
    set(ax,'Xlim',in_ps.TorqueFigParams.Xlim);
    set(ax,'Ylim',[0, 14]);
    % 计算总跨度（以毫秒为单位）
    totalSpan = (in_ps.TorqueFigParams.Xlim(2) - in_ps.TorqueFigParams.Xlim(1)) * 1000; % 转换为毫秒
    
    % 计算间隔（平均分成4部分）
    interval = totalSpan / 4;
    
    % 生成 x 轴的标签
    xt = 0:interval:totalSpan;
    xtls = string(arrayfun(@num2str, xt, 'UniformOutput', false));
    xt=xt/1000+in_ps.TorqueFigParams.Xlim(1);% 将标记转换回秒
    set(ax, 'XTick', xt); 
    set(ax, 'XTickLabel', xtls);
    set(ax,'XGrid','on');
    set(ax,'YGrid','on');
    set(ax,'YminorGrid','on');
    set(ax,'XminorGrid','on');
    xlabel(ax,'Time(ms)', ...
        'Units','normalized', ...
        'Position',[0.5 -0.2], ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'FontWeight','bold',...
        'FontSize',in_ps.TorqueFigParams.FontSize);
    ylabel(ax,'Torque(N.m)', ...
        'Units','normalized', ...
        'Position',[-0.10 0.5], ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'FontWeight','bold',...
        'FontSize',in_ps.TorqueFigParams.FontSize);
% set(ax1,'Xlim',[start_TIME END_TIME]);
% set(ax1,'XGrid','on');
% set(ax1,'XminorGrid','on');
% set(ax1,'YGrid','on');
% set(ax1,'YminorGrid','on');
% set(ax1,'LineWidth',1);
% set(ax1,'FontName','Times New Roman','FontSize',9,'FontWeight','bold');
% % xticklabels(ax1,{0,0.02,0.04,0.06,0.08,0.1});
% yticks([0,5,10]);
% ylabel(ax1,'\bf Torque(N.m)', ...
%     'Interpreter','latex', ...
%     'Units','normalized', ...
%     'Position',[-0.075 0.5], ...
%     'HorizontalAlignment','center', ...
%     'VerticalAlignment','middle', ...
%     'FontSize',9, ...
%     'FontName','Times New Roman','FontWeight','bold');
% xlabel(ax1,'Time(s)', ...
%     'Units','normalized', ...
%     'Position',[0.5 -0.2], ...
%     'HorizontalAlignment','center', ...
%     'VerticalAlignment','middle', ...
%     'FontSize',9, ...
%     'FontName','Times New Roman','FontWeight','bold');
%     % 创建 line
% annotation(fig,'line',[0.45 0.45],...
%     [0.229 0.981],...
%     'Color',[0.15 0.15 0.15],...
%     'LineWidth',1,...
%     'LineStyle','--');
% 
% % 创建 line
% annotation(fig,'line',[0.3 0.3],...
%     [0.229 0.981],...
%     'Color',[0.15 0.15 0.15],...
%     'LineWidth',1,...
%     'LineStyle','--');
% % 创建 textbox
% annotation(fig,'textbox',...
%     [0.129 0.8 0.176 0.151],...
%     'String','Heathy',...
%     'FontWeight','bold',...
%     'FontSize',8,...
%     'FontName','Times New Roman',...
%     'EdgeColor','none');
% 
% % 创建 textbox
% annotation(fig,'textbox',...
%     [0.572 0.8 0.276 0.151],...
%     'String','Fault-tolerant',...
%     'FontWeight','bold',...
%     'FontSize',8,...
%     'FontName','Times New Roman',...
%     'FitBoxToText','off',...
%     'EdgeColor','none');
% 
% % 创建 textbox
% annotation(fig,'textbox',...
%     [0.316 0.8 0.147 0.151],...
%     'String','Fault',...
%     'FontWeight','bold',...
%     'FontSize',8,...
%     'FontName','Times New Roman',...
%     'EdgeColor','none');
leg1=legend(ax,'\boldmath{$T_L$}','\boldmath{$T_{ref}$}',...
        'Interpreter','latex', ...
        'Location','northeast', ...
        'AutoUpdate','off', ...
        'FontName','Times New Roman', ...
        'FontSize',8, ...
        'Orientation','vertical', ...
        'Box','off');
    leg1.ItemTokenSize=[10,10];
    annotation(fig,'textbox',...
    [0.152943462897527 0.273049652830084 0.134472020148859 0.202127652134455],...
    'String',Tripple_result_str,...
    'Interpreter','latex',...
    'FontWeight','bold',...
    'FontSize',8,...
    'FontName','Times New Roman',...
    'EdgeColor','none');
end