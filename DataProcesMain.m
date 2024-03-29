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
%%
% 绘制相电流
[Fig1,plotSetup,MotorMeasurements]=plotCurrentWaveform(plotSetup, MotorMeasurements);

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
