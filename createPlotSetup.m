function out = createPlotSetup(in)
    % 创建绘图参数的结构体
    out = struct();

    % 设置绘图参数
    out.Current.StartTime = 0.0;               % 开始时间(s)
    out.Current.EndTime = 0.1;                  % 持续时间(s)


    out.Current.StartPoint = out.Current.StartTime/ ...
        str2double(in.SampleInterval.Channel1);
    %检查初始值是否为0
    if out.Current.StartPoint == 0
        out.Current.StartPoint=1;
    end
    out.Current.StartPoint=floor(out.Current.StartPoint);
    out.Current.EndPoint =out.Current.EndTime/ ...
        str2double(in.SampleInterval.Channel1);
    out.Current.EndPoint=floor(out.Current.EndPoint);
    out.MotorParams.MotorSpeed = 400;            % 电机转速（单位：r/min）
    out.MotorParams.PolePairs = 31;              % 电机极对数
    out.MotorParams.EleFreq = out.MotorParams.MotorSpeed * ...
        out.MotorParams.PolePairs / 60;
    %电流绘图的参数
    out.CurrentFigParams.FontSize = 8;                % 字体大小
    out.CurrentFigParams.LineWidth = 1.2;             % 线条宽度
    out.CurrentFigParams.AxisLineWidth = 1.0;         % 坐标轴线宽
    out.CurrentFigParams.YZoomin = 1.75;
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
    out.TorqueFigParams.LineWidth = 1.0;             % 线条宽度
    out.TorqueFigParams.AxisLineWidth = 1.0;         % 坐标轴线宽
    out.TorqueFigParams.Xlim = [out.Current.StartTime,out.Current.EndTime];
    out.TorqueFigParams.Width = 8.8;               % 绘图宽度（单位：CM）
    out.TorqueFigParams.Height = 4;              % 绘图高度（单位：CM）
    out.TorqueFigParams.Units = 'centimeters';
    out.TorqueFigParams.Color=["#CD1818","#0F2C67"];
    out.TorqueFigParams.ExportDPI = "-r600";         % 导出图片的DPI
    out.TorqueFigParams.ExportFormat = '-dpng';      % 导出图片的格式
    %电流绘图的参数
    out.FFTParams.StartTime = 0.0;               % 开始时间(百分比)
    out.FFTParams.Length = 0.25;                  % 持续时间(百分比)

    % 检查参数之和是否大于1
    if out.FFTParams.StartTime + out.FFTParams.Length > 1
        error('设置错误：开始时间和持续时间之和超过了索引范围。');
    end

    out.FFTParams.StartPoint = out.FFTParams.StartTime * ...
        str2double(in.RecordLength.Channel1);
    out.FFTParams.EndPoint = out.FFTParams.StartPoint + ...
        out.FFTParams.Length * ...
        str2double(in.RecordLength.Channel1);
    
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