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

% 读取文件
MotorMeasurements=readFiles();
%%
% 配置绘图参数
plotSetup=createPlotSetup(MotorMeasurements);

%%
%移动数据
% aaaa=zeros(size(MotorMeasurements.Data.CH6));
% aaaa(1:end-75)=MotorMeasurements.Data.CH6(76:end);
% MotorMeasurements.Data.CH6=aaaa;
% 
% %移动数据
% aaaa=zeros(size(MotorMeasurements.Data.CH7));
% aaaa(76:end)=MotorMeasurements.Data.CH7(1:end-75);
% MotorMeasurements.Data.CH7=aaaa;
%%
% 绘制相电流
[Fig1,plotSetup,MotorMeasurements]=plotCurrentWaveform(plotSetup, MotorMeasurements);
%% 绘制dq电流（或转矩）
Fig2=PlotTorque(plotSetup, MotorMeasurements,5);
%%
% 绘制转速
Fig3=PlotSpeed(plotSetup, MotorMeasurements);
%%
% FFT
Fig4=PhaseCurrentFFT(plotSetup, MotorMeasurements);
%%
    Currenttime=string(datetime('now','Format','yyMMddHHmmss'));
    exportgraphics(Fig1, ...
    strcat(MotorMeasurements.pathName,'current_',MotorMeasurements.fileName(1:6),'_', ...
    Currenttime,'.png'),'Resolution',300);
%%
    Currenttime=string(datetime('now','Format','yyMMddHHmmss'));
    print(Fig2,plotSetup.CurrentFigParams.ExportFormat,plotSetup.CurrentFigParams.ExportDPI, ...
    strcat(MotorMeasurements.pathName,'Torque_',MotorMeasurements.fileName(1:6),'_', ...
    Currenttime,'.png'));
%%
    Currenttime=string(datetime('now','Format','yyMMddHHmmss'));
    print(Fig3,plotSetup.CurrentFigParams.ExportFormat,plotSetup.CurrentFigParams.ExportDPI, ...
    strcat(MotorMeasurements.pathName,'speed_',MotorMeasurements.fileName(1:6),'_', ...
    Currenttime,'.png'));
%%
    Currenttime=string(datetime('now','Format','yyMMddHHmmss'));
    exportgraphics(Fig4,strcat(MotorMeasurements.pathName,'FFT_',MotorMeasurements.fileName(1:6),'_', ...
    Currenttime,'.png'),'Resolution',150);
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
% 
% T_Martix=0.4*[1,cos(X),cos(2*X),cos(3*X),cos(4*X);
%               0,sin(X),sin(2*X),sin(3*X),sin(4*X); 
%               1,cos(3*X),cos(3*2*X),cos(3*3*X),cos(3*4*X); 
%               0,sin(3*X),sin(3*2*X),sin(3*3*X),sin(3*4*X);
%               0.5,0.5,0.5,0.5,0.5];
T_Martix=0.4*[1,cos(X),cos(2*X),cos(3*X),cos(4*X);
              0,sin(X),sin(2*X),sin(3*X),sin(4*X); 
              1,cos(3*X),cos(3*2*X),cos(3*3*X),cos(3*4*X); 
              0,sin(3*X),sin(3*2*X),sin(3*3*X),sin(3*4*X);
              0.5,0.5,0.5,0.5,0.5];
for i=1:length(MotorMeasurements.Data.(MotorMeasurements.DataName{1}))
    ialphabeta=T_Martix*[MotorMeasurements.Data.(MotorMeasurements.DataName{4})(i);...
                MotorMeasurements.Data.(MotorMeasurements.DataName{5})(i);...
                MotorMeasurements.Data.(MotorMeasurements.DataName{6})(i);...
                MotorMeasurements.Data.(MotorMeasurements.DataName{7})(i);...
                MotorMeasurements.Data.(MotorMeasurements.DataName{8})(i)];
    ialpha1(i)=ialphabeta(1,1);
    ibeta1(i)=ialphabeta(2,1);
    ialpha3(i)=ialphabeta(3,1);
    ibeta3(i)=ialphabeta(4,1);
end

Fig5=Plot_alphabeta(ialpha1, ibeta1, ialpha3, ibeta3,2);

%%
    Currenttime=string(datetime('now','Format','yyMMddHHmmss'));
    print(Fig5,plotSetup.CurrentFigParams.ExportFormat,plotSetup.CurrentFigParams.ExportDPI, ...
    strcat(MotorMeasurements.pathName,'alphabeta_',MotorMeasurements.fileName(1:5), ...
    Currenttime,'.png'));
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
