function out = createPlotSetup(in)
    % 创建绘图参数的结构体
    out = struct();

    % 设置电流绘图参数
    out.Current.StartTime = 0.5;               % 开始时间(s)
    out.Current.EndTime = 0.52;                  % 持续时间(s)
    % 设置转矩绘图参数
    out.Torque.StartTime = 0.3;               % 开始时间(s)
    out.Torque.EndTime = 0.4;                  % 持续时间(s)

    out.Current.StartPoint = out.Current.StartTime/ ...
        str2double(in.SampleInterval.Channel1);
    out.Torque.StartPoint = out.Torque.StartTime/ ...
        str2double(in.SampleInterval.Channel1);
    %检查初始值是否为0
    if out.Current.StartPoint == 0
        out.Current.StartPoint=1;
    end
    if out.Torque.StartPoint == 0
        out.Torque.StartPoint=1;
    end
    % 计算电流的起点和终点
    out.Current.StartPoint=floor(out.Current.StartPoint);
    out.Current.EndPoint =out.Current.EndTime/ ...
        str2double(in.SampleInterval.Channel1);
    out.Current.EndPoint=floor(out.Current.EndPoint);
    %计算转矩的起点和终点
    out.Torque.StartPoint=floor(out.Torque.StartPoint);
    out.Torque.EndPoint =out.Torque.EndTime/ ...
        str2double(in.SampleInterval.Channel1);
    out.Torque.EndPoint=floor(out.Torque.EndPoint);

    out.MotorParams.MotorSpeed = 200;            % 电机转速（单位：r/min）
    out.MotorParams.PolePairs = 31;              % 电机极对数
    out.MotorParams.EleFreq = out.MotorParams.MotorSpeed * ...
        out.MotorParams.PolePairs / 60;
    %电流绘图的参数
    out.CurrentFigParams.FontSize = 8;                % 字体大小
    out.CurrentFigParams.LineWidth = 1.2;             % 线条宽度
    out.CurrentFigParams.AxisLineWidth = 1.0;         % 坐标轴线宽
    out.CurrentFigParams.YZoomin = 1.5;
    out.CurrentFigParams.Xlim = [out.Current.StartTime,out.Current.EndTime];
    out.CurrentFigParams.Width = 6;               % 绘图宽度（单位：CM）
    out.CurrentFigParams.Height = 3;              % 绘图高度（单位：CM）
    out.CurrentFigParams.Units = 'centimeters';
    out.CurrentFigParams.Color=["#CD1818","#2980b9","#16a085",...
        "#8e44ad","#f39c12"];
    out.CurrentFigParams.ExportDPI = "-r600";         % 导出图片的DPI
    out.CurrentFigParams.ExportFormat = '-dpng';      % 导出图片的格式

    %转矩绘图的参数
    out.TorqueFigParams.FontSize = 8;                % 字体大小
    out.TorqueFigParams.LineWidth = 2;             % 线条宽度
    out.TorqueFigParams.AxisLineWidth = 1.0;         % 坐标轴线宽
    out.TorqueFigParams.Xlim = [out.Torque.StartTime,out.Torque.EndTime];
    out.TorqueFigParams.Width = 6;               % 绘图宽度（单位：CM）
    out.TorqueFigParams.Height = 3;              % 绘图高度（单位：CM）
    out.TorqueFigParams.Units = 'centimeters';
    out.TorqueFigParams.Color=["#CD1818","#0F2C67"];
    out.TorqueFigParams.ExportDPI = "-r600";         % 导出图片的DPI
    out.TorqueFigParams.ExportFormat = '-dpng';      % 导出图片的格式
   
    
    %FFT绘图的参数
    out.FFTParams.StartTime = 0.5;               % 开始时间(s)
    out.FFTParams.EndTime = 0.6;                  % 结束时间(s)
    out.FFTParams.StartPoint = out.FFTParams.StartTime/ ...
        str2double(in.SampleInterval.Channel1);
    %检查初始值是否为0
    if out.FFTParams.StartPoint == 0
        out.FFTParams.StartPoint=1;
    end
    out.FFTParams.StartPoint=floor(out.FFTParams.StartPoint);
    out.FFTParams.EndPoint =out.FFTParams.EndTime/ ...
        str2double(in.SampleInterval.Channel1);
    out.FFTParams.EndPoint=floor(out.FFTParams.EndPoint);
    out.FFTParams.FTT_Basecycle=floor((out.FFTParams.EndTime- ...
        out.FFTParams.StartTime)*out.MotorParams.EleFreq);
    out.FFTParams.FFTresulatName='Current_FFT_A';
    out.FFTParams.maxFrequency=10000;
    out.FFTParams.ExportDPI = "-r600";         % 导出图片的DPI
    out.FFTParams.ExportFormat = '-dpng';      % 导出图片的格式

    osType = computer;
    if startsWith(osType, 'PCWIN')
        disp('当前系统是 Windows');
        computerdpi=96;
    elseif startsWith(osType, 'MAC')
        computerdpi=72;
        disp('当前系统是 Macintosh');
    else
        disp('当前系统是Linux');
    end

    out.screenSize=get(0, 'screensize')/computerdpi*2.54; %电脑屏幕尺寸大小
    % 显示结构体内容
% displayStruct(out);
end

function displayStruct(structure, indent)
    if nargin < 2
        indent = ''; % 默认无缩进
    end

    if ~isstruct(structure)
        error('输入必须是一个结构体');
    end

    fields = fieldnames(structure); % 获取所有字段名
    for i = 1:length(fields)
        fieldName = fields{i};
        fieldValue = structure.(fieldName);

        if isstruct(fieldValue) % 如果字段是结构体，则递归调用
            disp([indent, fieldName, ':']);
            displayStruct(fieldValue, [indent, '    ']);
        else % 否则直接显示字段名和值
            disp([indent, fieldName, ': ', mat2str(fieldValue)]);
        end
    end
end