function [FFT_outputname,FFTdata]=PhaseCurrentFFT(MotorCurrent, Start_Point, ...
    End_Point, FunFrq, Current_Start_Time, ...
    FTT_Basecycle,MaxFrequency, FFTresulatName)
%Construct structure data from the input data for analysis,
% more details on "power_fftscope" can be found at
% https://mathworks.com/help/sps/powersys/ref/power_fftscope.html
FFTdata.time=MotorCurrent.time([Start_Point:1:End_Point],:);
FFTdata.signals.values=MotorCurrent.a([Start_Point:1:End_Point],:);
FFTdata.signals.dimensions=1;
FFTdata.blockName='FFT_Analyse/Scope';
FFTdata.signals.label='';
FFTdata.signals.title='';
FFTdata.signals.plotStyle=0;
FFTdata.input=1;
FFTdata.signal=1;
FFTdata.fundamental=FunFrq;
FFTdata.startTime=Current_Start_Time;
FFTdata.cycles=FTT_Basecycle;
FFTdata.maxFrequency=MaxFrequency;
FFTdata.THDmaxFrequency=inf;
FFTdata.THDbase='fund';
FFTdata.freqAxis='Hertz';
FFTdata=power_fftscope(FFTdata);

%Displaying the results of FFT analysis
power_fftscope(FFTdata);

%Aggregate the analysed data into arrays
FFT_final_result=[FFTdata.freq/FunFrq,...
    FFTdata.mag/FFTdata.magFundamental*100,FFTdata.mag];

%Determine the file name with the timestamp
FFT_outputname=strcat(FFTresulatName,'-', ...
    string(datetime('now','Format','uuuu-MM-dd-HH-mm')),'.csv');

%Writing data to csv files
writematrix(FFT_final_result,FFT_outputname);
end