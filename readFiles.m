function result = readFiles()
    desktopPath = fullfile(getenv('USERPROFILE'), 'Desktop');
    % 打开文件选择对话框
    [fileName, pathName] = uigetfile({'*.csv', 'CSV Files (*.csv)'; '*.*', ...
        'All Files (*.*)'}, 'Select a CSV file',desktopPath);
    
    % 检查用户是否选择了文件
    if isequal(fileName, 0) || isequal(pathName, 0)
        disp('用户取消了选择');
    else
        filePath = fullfile(pathName, fileName); % 获取完整的文件路径
        disp(['用户选择了文件：', filePath]);
    end    
    % 打开文件
    fid = fopen(filePath, 'rt');
    if fid == -1
        error('无法打开文件: %s', filePath);
    end

    % 初始化一个结构体来存储所有的定义
    result = struct();
    result.fileName=fileName; %文件名
    result.pathName=pathName; %路径名
    result.filePath=filePath; %完整路径
    result.Data = struct(); % 初始化数据存储结构体
    result.Data.Timebase = []; % 初始化时间基准数据
    dataReading = false; % 标志变量，用于标识是否开始读取数据

    % 按行读取文件
    while ~feof(fid)
        line = fgetl(fid); % 读取一行

        if startsWith(line, 'TIME') % 检查是否为数据开始的行
            dataReading = true; % 开始读取数据
            channelNames = strsplit(line, ',');
            for i = 2:length(channelNames) % 从第二个元素开始，因为第一个是'TIME'
                result.Data.(strtrim(['Channel', num2str(i-1)])) = []; % 初始化通道数据
            end
            continue; % 继续到下一行
        end

    if dataReading
        dataTokens = strsplit(line, ',');
        timeValue = str2double(dataTokens{1}); % 将时间值转换为double类型
        result.Data.Timebase = [result.Data.Timebase; timeValue]; % 存储时间数据

        for i = 2:length(dataTokens)
            channelData = str2double(dataTokens{i});
            channelName = strtrim(['Channel', num2str(i-1)]);
            result.Data.(channelName) = [result.Data.(channelName); channelData]; % 追加数据
        end
    else
        % 分割整行以获取所有的键值对
        tokens = strsplit(line, ',');
        
        % 初始化一个临时结构体来存储当前行的键值对
        tempStruct = struct();
        
        % 遍历所有的tokens来找到关键字和值
        for i = 1:length(tokens)
            % 去除空格
            token = strtrim(tokens{i});
            % 检查token是否是一个关键字
            if any(strcmp(token, {'Model', 'Channel','Waveform Type','Record Length','Sample Interval', 'Vertical Units'}))
                % 提取关键字
                key = strrep(token, ' ', ''); % 删除空格以创建有效的字段名
                % 检查下一个token是否存在，以避免越界
                if i < length(tokens)
                    % 提取值
                    value = strtrim(tokens{i+1});
                    % 存储到临时结构体中
                    if ~isfield(tempStruct, key)
                        tempStruct.(key) = {};
                    end
                    tempStruct.(key){end+1} = value;
                end
            end
        end
        
        % 处理临时结构体中的每个关键字和对应的值
        fieldNames = fieldnames(tempStruct);
        for i = 1:length(fieldNames)
            key = fieldNames{i};
            valueArray = tempStruct.(key);
            if length(valueArray) == 1
                % 如果只有一个值，直接保存
                result.(key) = valueArray{1};
            else
                % 如果有多个值，创建一个嵌套结构体
                if ~isfield(result, key)
                    result.(key) = struct();
                end
                for j = 1:length(valueArray)
                    nestedKey = ['Channel', num2str(j)];
                    result.(key).(nestedKey) = valueArray{j};
                end
            end
        end
    end
    end

fclose(fid); % 关闭文件
result.Data.Timebase=result.Data.Timebase-result.Data.Timebase(1);
disp('数据读取完毕.');
displayStruct(result);
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
