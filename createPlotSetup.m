function r = createPlotSetup(MotorMeasurements)
    % 创建绘图参数的结构体
    r = struct();

    % 设置绘图参数
    r.Current.StartTime = 0.0;               % 开始时间(百分比)
    r.Current.Length = 0.2;                  % 持续时间(百分比)

    % 检查参数之和是否大于1
    if r.Current.StartTime + r.Current.Length > 1
        error('设置错误：开始时间和持续时间之和超过了索引范围。');
    end

    r.Current.StartPoint = r.Current.StartTime * ...
        str2double(MotorMeasurements.RecordLength.Channel1);
    %检查初始值是否为0
    if r.Current.StartPoint ==0
        r.Current.StartPoint=1;
    end
    r.Current.EndPoint = r.Current.StartPoint + ...
        r.Current.Length * ...
        str2double(MotorMeasurements.RecordLength.Channel1);

    r.MotorParams.MotorSpeed = 400;            % 电机转速（单位：r/min）
    r.MotorParams.PolePairs = 31;              % 电机极对数
    r.MotorParams.EleFreq = r.MotorParams.MotorSpeed * ...
        r.MotorParams.PolePairs / 60;

    r.CurrentFigParams.FontSize = 8;                % 字体大小
    r.CurrentFigParams.LineWidth = 1.0;             % 线条宽度
    r.CurrentFigParams.AxisLineWidth = 1.0;         % 坐标轴线宽
    r.CurrentFigParams.YZoomin = 1.75;
    r.CurrentFigParams.Width = 6;               % 绘图宽度（单位：CM）
    r.CurrentFigParams.Height = 3;              % 绘图高度（单位：CM）
    r.CurrentFigParams.Units = 'centimeters';
    r.CurrentFigParams.Color=["#e74c3c","#2980b9","#16a085",...
        "#8e44ad","#f39c12"];
    r.CurrentFigParams.ExportDPI = "-r300";         % 导出图片的DPI
    r.CurrentFigParams.ExportFormat = '-dpng';      % 导出图片的格式

    r.FFTParams.StartTime = 0.0;               % 开始时间(百分比)
    r.FFTParams.Length = 0.5;                  % 持续时间(百分比)

    % 检查参数之和是否大于1
    if r.FFTParams.StartTime + r.FFTParams.Length > 1
        error('设置错误：开始时间和持续时间之和超过了索引范围。');
    end

    r.FFTParams.StartPoint = r.FFTParams.StartTime * ...
        str2double(MotorMeasurements.RecordLength.Channel1);
    r.FFTParams.EndPoint = r.FFTParams.StartPoint + ...
        r.FFTParams.Length * ...
        str2double(MotorMeasurements.RecordLength.Channel1);
    
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

    r.screenSize=get(0, 'screensize')/computerdpi*2.54; %电脑屏幕尺寸大小
    % 显示结构体内容
displayStruct(r);
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