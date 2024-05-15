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
    result.DataStartRow=0;
    Numbers = 0;
    % 按行读取文件
    while ~feof(fid) && Numbers<50
        line = fgetl(fid); % 读取一行
        Numbers=Numbers + 1;
        if contains(line, 'TIME','IgnoreCase',true)
             result.DataStartRow = Numbers;
            continue; % 继续到下一行
        end
        
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
fclose(fid); % 关闭文件

result.Data=table2struct(readtable(filePath,'Range', result.DataStartRow),'ToScalar',true);
% 获取结构体中所有字段的名称
fieldNames = fieldnames(result.Data);
% 选择第一个字段
firstFieldName = fieldNames{1};
% 对第一个字段中的每个元素减去该字段的第一个元素
result.Data.(firstFieldName) = result.Data.(firstFieldName) - result.Data.(firstFieldName)(1);
% result.Data.(fieldNames{3}) = result.Data.(fieldNames{3})/10;
% result.Data.(fieldNames{6}) = result.Data.(fieldNames{6})/50;
disp('数据读取完毕.');
disp(result.fileName);
disp(result.filePath);
end