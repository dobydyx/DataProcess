%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  DataProcess_Main
%  Version: 1.0
%  Author: dyxdoby
% 
%  This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation; either version 2 of the License, or 
% (at your option) any later version.
% 
%  This program is distributed in the hope that it will be useful, 
% but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
% General Public License for more details.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear Command Window
clc;

% Remove items from workspace, freeing up system memory
clear ;

close all;
% Sample Interval. Based on the different oscilloscope, which can be 
% obtained from the data file.
%%
% 读取文件
MotorMeasurements=readFiles();
%%
% 配置绘图参数
plotSetup=createPlotSetup(MotorMeasurements);
%% 开始绘制电流波形
Fig1=figure;
set(Fig1,'Units',plotSetup.CurrentFigParams.Units,'position', ...
    [3 3 plotSetup.CurrentFigParams.Width plotSetup.CurrentFigParams.Height],'Resize',0);
plotSetup.CurrentFigParams.InnerPostion=get(Fig1, 'Position');
plotSetup.CurrentFigParams.OuterPostion=get(Fig1, 'OuterPosition');
ax=axes('position',[0.11 0.22 0.85 0.75]);
MotorMeasurements.DataName=fieldnames(MotorMeasurements.Data)';
for i=1:5
    plot(ax,MotorMeasurements.Data.(MotorMeasurements.DataName{1})([plotSetup.Current.StartPoint:plotSetup.Current.EndPoint],1), ...
        MotorMeasurements.Data.(MotorMeasurements.DataName{3+i})([plotSetup.Current.StartPoint:plotSetup.Current.EndPoint],1), ...
        'color',plotSetup.CurrentFigParams.Color(i),...
        'LineWidth',plotSetup.CurrentFigParams.LineWidth);
    MotorMeasurements.Maxcurrent(i)=max(MotorMeasurements.Data.(MotorMeasurements.DataName{3+i})([plotSetup.Current.StartPoint:plotSetup.Current.EndPoint],1));
    hold on
end
set(ax,'FontName','Times New Roman', ...
    'FontSize',plotSetup.CurrentFigParams.FontSize, ...
    'FontWeight','bold', ...
    'GridLineStyle','--', ...
    'LineWidth',0.9, ...
    'GridAlpha',0.2);
set(ax,'Xlim',[plotSetup.Current.StartTime,plotSetup.Current.StartTime+...
    round(max(MotorMeasurements.Data.Timebase),1)*plotSetup.Current.Length]);
set(ax,'Ylim',[-plotSetup.CurrentFigParams.YZoomin*max(MotorMeasurements.Maxcurrent), ...
                plotSetup.CurrentFigParams.YZoomin*max(MotorMeasurements.Maxcurrent)]);
xticklabels(ax,{'0','5','10','15','20'});
set(ax,'XGrid','on');
set(ax,'YGrid','on');
xlabel(ax,'Time(ms)', ...
    'Units','normalized', ...
    'Position',[0.5 -0.2], ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', ...
    'FontWeight','bold',...
    'FontSize',plotSetup.CurrentFigParams.FontSize);
ylabel(ax,'Current(A)', ...
    'Units','normalized', ...
    'Position',[-0.10 0.5], ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', ...
    'FontWeight','bold',...
    'FontSize',plotSetup.CurrentFigParams.FontSize);
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

%% Plot Five-phase Current with annotation
Fig1=Plot_FivephaseCurrent(Pic_Width, Pic_Height, MotorCurrent, Start_Point, ...
    End_Point, linewidth, Current_Start_Time, Current_End_Time, ...
    YZoomin, font_size);

%Add_Annotation to this figure
Add_Annotation_toPhasecurrent(linewidth, font_size);
%% Caculate phase current FFT
% FFT analysis using "power_fftscope" is achieved by constructing 
% structures for the input of data.
% The same FFT analysis functions are then obtained as in simulink.

%Set the start and end time of the data to be analysed by FFT.
%The time should be set within the time range of the oscilloscope and the 
% maximum value of "MotorCurrent.time" can be checked 
% to determine the valid recording time.
FFT_Start_Time=0.0; FFT_End_Time=0.6;

%Find the start and end points of the array 
% according to the set time range.
Start_Point=floor(FFT_Start_Time/(Tmin))+1;
End_Point=floor(FFT_End_Time/Tmin);

%Calculation of the fundamental electrical frequency 
% based on the parameters of the motor
FunFrq=SpeedRef*Polepairs/60;

%Setting the cut-off frequency for FFT analysis
MaxFrequency=60000; %60kHz

%File name of the analyzed data saved as a CSV file
FFTresulatName='Current_FFT_A';

%Calculation of the maximum number of complete 
% electrical cycles in the current time frame
%You can set the period you want, 
% as long as it does not exceed a value within this time scale
FTT_Basecycle=floor((FFT_End_Time-FFT_Start_Time)*FunFrq);

%Calculating the FFT for phase currents
[FFT_outputname,FFTdata]=PhaseCurrentFFT(MotorCurrent, Start_Point, ...
    End_Point, FunFrq,FFT_Start_Time,18, ...
    MaxFrequency, FFTresulatName);

%% Re-plotting the phase current FFT data
%The original FFT analysis results were not clear enough to meet the 
% requirements of the journal, so the FFT analysis results were re-plotted.

%Read the output file
FFT_WaveData=csvread(FFT_outputname,0,0);

%Plotting FFT images
Fig2=RepoltFFT(FFT_WaveData, FunFrq, MaxFrequency, FFTdata);

%% 绘制\alpha\-\beta轴电流轨迹
X = 2*pi/5;

T_Martix=0.4*[1,cos(X),cos(2*X),cos(3*X),cos(4*X);
              0,sin(X),sin(2*X),sin(3*X),sin(4*X); 
              1,cos(3*X),cos(3*2*X),cos(3*3*X),cos(3*4*X); 
              0,sin(3*X),sin(3*2*X),sin(3*3*X),sin(3*4*X);
              0.5,0.5,0.5,0.5,0.5];
for i=1:length(MotorCurrent.a)
    ialphabeta=T_Martix*[MotorCurrent.a(i);MotorCurrent.b(i);...
        MotorCurrent.c(i);MotorCurrent.d(i);MotorCurrent.e(i)];
    ialpha1(i)=ialphabeta(1,1);
    ibeta1(i)=ialphabeta(2,1);
    ialpha3(i)=ialphabeta(3,1);
    ibeta3(i)=ialphabeta(4,1);
end

Fig3=Plot_alphabeta(ialpha1, ibeta1, ialpha3, ibeta3,linewidth);

%% 转矩
Fig4=PlotTorque(MotorTorque, MotorCurrent, Tmin,0,0.1);

%%

%Print the drawn image, make sure the image is not turned off
Currenttime=string(datetime('now','Format','uuuu-MM-dd-HH-mm-ss'));

print(Fig1,'-dtiff',"-r192",strcat('Five-phase-Current@192dpi-' ...
    ,Currenttime,'.tiff'));

print(Fig2,'-dtiff',"-r192",strcat('FFT-result-PhaseA@192dpi-' ...
    ,Currenttime,'.tiff'));

print(Fig3,'-dtiff',"-r192",strcat('alphabetaCurrent@192dpi-' ...
    ,Currenttime,'.tiff'));

print(Fig4,'-dtiff',"-r192",strcat('Torque@192dpi-' ...
    ,Currenttime,'.tiff'));
