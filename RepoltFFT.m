function Fig2=RepoltFFT(FFT_WaveData, FunFrq, MaxFrequency, FFTdata)

% Create a new figure
Fig2=figure;
set(Fig2,'Units','centimeter','position',[0 0 8.8 4.4]);

% Create the first axes for the plot
ax1=axes('position',[0.1 0.8 0.85 0.15]);

% Plot the FFT data on the first axes
plot(FFT_WaveData(:,1)*FunFrq,FFT_WaveData(:,2),'LineWidth',2,'Color','k');

% Set the limits of the y-axis and x-axis for the first plot
set(ax1,'Ylim',[90 110]);
set(ax1,'Xlim',[0,MaxFrequency]);

% Set the ticks for the y-axis
yticks([100]);
yticklabels({100});

% Remove the labels for the x-axis
xticklabels({});
% Set the font, size, and weight for the first plot
set(ax1,'FontName','Times New Roman','FontSize', 9,'FontWeight','bold');
% Enable the grid for the first plot
set(ax1,'XGrid','on');
set(ax1,'XMinorGrid','on','ClippingStyle','rectangle');

set(ax1,'YMinorGrid','on');
set(ax1,'YGrid','on');
% Calculate the Total Harmonic Distortion (THD) and the fundamental frequency
THDresult_str=strcat('THD=',num2str(roundn(FFTdata.THD,-2)),'%');
Fundresult_str=strcat('Fundamental=',num2str(roundn(FFTdata.magFundamental,-2)),'A');
% Create the second axes for the plot
ax2=axes('position',[0.1 0.2 0.85 0.55]);
% Plot the FFT data on the second axes
plot(FFT_WaveData(:,1)*FunFrq,FFT_WaveData(:,2),'LineWidth',2,'Color','k');
% Set the limits of the y-axis and x-axis for the second plot
set(ax2,'Ylim',[0 5]);
set(ax2,'Xlim',[0,MaxFrequency]);

% Add annotations to the figure
annotation(Fig2,'rectangle',[0.1 0.75 0.85 0.05],'FaceColor', ...
    [0.941176470588235 0.941176470588235 0.941176470588235], ...
    'FaceAlpha',0.5,'LineWidth',0.7);
annotation(Fig2,'line',[0.09 0.11],[0.75 0.77],'LineWidth',0.7);
annotation(Fig2,'line',[0.09 0.11],[0.77 0.79],'LineWidth',0.7);
annotation(Fig2,'line',[0.94 0.96],[0.76 0.78],'LineWidth',0.7);
annotation(Fig2,'line',[0.94 0.96],[0.78 0.80],'LineWidth',0.7);

% Add text annotations for the THD and the fundamental frequency
annotation(Fig2,'textbox',...
    [0.665464962121214 0.799763260443102 0.285963899037494 0.156344694102352],...
    'Color',[0.635294117647059 0.0784313725490196 0.184313725490196],...
    'String',{THDresult_str},...
    'Interpreter','none',...
    'FontWeight','bold',...
    'FontName','Times New Roman',...
    'EdgeColor','none');

annotation(Fig2,'textbox',...
     [0.165464962121214 0.799763260443102 0.285963899037494 0.156344694102352],...
    'Color',[0.635294117647059 0.0784313725490196 0.184313725490196],...
    'String',{Fundresult_str},...
    'Interpreter','none',...
    'FontWeight','bold',...
    'FontName','Times New Roman',...
    'EdgeColor','none');

set(ax2,'FontName','Times New Roman','FontSize', 9,'FontWeight','bold');
xlabel('Frequency(Hz)','Units','normalized','Position',[0.5 -0.25],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',9);
ylabel('Mag (% of Fundamental)','Units','normalized','Position',[-0.1 0.55],'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',9);
set(ax2,'XGrid','on');
set(ax2,'XMinorGrid','on','ClippingStyle','rectangle');
set(ax2,'YMinorGrid','on');
set(ax2,'YGrid','on');

ax3=axes('position',[0.3 0.4 0.45 0.3]);
plot(FFT_WaveData(:,1),FFT_WaveData(:,2),'LineWidth',2,'Color','k');
set(ax3,'Ylim',[0 5]);
set(ax3,'Xlim',[0 10]);
set(ax3,'FontName','Times New Roman','FontSize', 9,'FontWeight','bold');
set(ax3,'XGrid','on');
set(ax3,'XMinorGrid','on','ClippingStyle','rectangle');

set(ax3,'YMinorGrid','off');
set(ax3,'YGrid','on');

xlabel('Harmonic Order','Units','normalized','Position',[0.5 -0.40], ...
    'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',9);
annotation(Fig2,'line',[0.302884615384615 0.108173076923077],...
    [0.663461538461539 0.538461538461539],'LineStyle','--');
annotation(Fig2,'line',[0.766826923076923 0.132211538461538],...
    [0.388423076923077 0.201923076923077],'LineStyle','--');
annotation(Fig2,'rectangle',...
    [0.104807692307692,0.2,0.044673076923077,0.326923076923077],...
    'FaceColor',[0.8 0.8 0.8],...
    'FaceAlpha',0.5,'LineStyle','--','LineWidth',1);

annotation(Fig2,'textarrow',[0.855769230769231 0.814903846153846],...
    [0.486778846153846 0.337740384615385],'String',{'Switch','harmonic'},...
    'HeadWidth',5,...
    'HeadLength',7,...
    'FontSize',9,'FontWeight','bold',...
    'FontName','Times New Roman');
end