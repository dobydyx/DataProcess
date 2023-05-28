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
% clear ;

close all;
% Sample Interval. Based on the different oscilloscope, which can be 
% obtained from the data file.
Tmin=3.2e-6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Data Acquisition%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reads a data file. The number of starting rows and columns is based on 
% the valid data area in the CSV file.
WaveData=csvread('.\Demo\Tek000_ALL.csv',12,0); 

% Move the time base of the oscilloscope to 0.
MotorCurrent.time=WaveData(:,1)-WaveData(1,1);

%Extraction the column of phase A current data
MotorCurrent.a=WaveData(:,5);

%Extraction the column of phase B current data
MotorCurrent.b=WaveData(:,6);

%Extraction the column of phase C current data
MotorCurrent.c=WaveData(:,7);

%Extraction the column of phase D current data
MotorCurrent.d=WaveData(:,8);

%Extraction the column of phase E current data
MotorCurrent.e=WaveData(:,9);

%%
%%%%%%%%%%%%%%%%%%%Setting and Plotting current waveforms%%%%%%%%%%%%%%%%%%
%Set the start and end time for drawing the waveform
Current_Start_Time=0.1;                Current_End_Time=0.3;

Start_Point=floor(Current_Start_Time/Tmin);

End_Point=floor(Current_End_Time/Tmin);
%Set the font size and line width in figure
font_size=8;                           linewidth=1;

SpeedRef=300;                          Polepairs=31;
%Set the width and height of the figure (Units:centimeters)
% Most charts, graphs, and tables are one column wide (3.5
% inches / 88 millimeters / 21 picas) or page wide (7.16 inches /
% 181 millimeters / 43 picas). The maximum depth a graphic can
% be is 8.5 inches (216 millimeters / 54 picas)
Pic_Width=8.8;                         Pic_Height=6.6;

%Scaling factor for coordinate axis Y, 
% based on the maximum value of the current data
YZoomin=1.75;

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
FFT_Start_Time=0.3; FFT_End_Time=0.4;

%Find the start and end points of the array 
% according to the set time range.
Start_Point=floor(FFT_Start_Time/(Tmin));
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
    End_Point, FunFrq,FFT_Start_Time,FTT_Basecycle, ...
    MaxFrequency, FFTresulatName);

%% Re-plotting the phase current FFT data
%The original FFT analysis results were not clear enough to meet the 
% requirements of the journal, so the FFT analysis results were re-plotted.

%Read the output file
FFT_WaveData=csvread(FFT_outputname,0,0);

%Plotting FFT images
Fig2=RepoltFFT(FFT_WaveData, FunFrq, MaxFrequency, FFTdata);

%%
%Print the drawn image, make sure the image is not turned off
Currenttime=string(datetime('now','Format','uuuu-MM-dd-HH-mm-ss'));

print(Fig1,'-dtiff',"-r600",strcat('.\Demo\','Five-phase-Current@600dpi-' ...
    ,Currenttime,'.tiff'));

print(Fig2,'-dtiff',"-r600",strcat('.\Demo\','FFT-result-PhaseA@600dpi-' ...
    ,Currenttime,'.tiff'));