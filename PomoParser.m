% 该脚本用于将导出的番茄土豆网站记录的CSV文件进行处理和拆分，并生成新的CSV文件用于进一步统计操作。
%
%
% Sam Z. Shan with the draft and help from ChatGPT
% May 13, 2023


% 读取CSV文件
data = readtable('Pomos - 2014-04-01 - 2023-05-12.csv');
default_timezone = 8;% +08:00 Beijing

% 创建新的数据表
newData = table();
newData.uuid = strings(0);
newData.start_date = strings(0);
newData.start_time = strings(0);
newData.end_time = strings(0);
newData.description = strings(0);
newData.approximate = zeros(0, 1);
newData.duration = zeros(0);

% 遍历每一行记录
for ii = 1:size(data, 1)
    % 获取当前记录的信息
    datetimeStr = data.started_at{ii};
    endTimeStr = data.ended_at{ii};
    description = data.description{ii};
    
    % 解析日期、开始时间和结束时间
    pattern = '(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}:\d{2})([-+]\d{2}:\d{2})';
    tokens = regexp(datetimeStr, pattern, 'tokens');
    stDateStr = tokens{1}{1};
    startTimeStr = tokens{1}{2};
    timezoneStr = tokens{1}{3};
    
    tokens = regexp(endTimeStr, pattern, 'tokens');
    endTimeStr = tokens{1}{2};
    edDateStr = tokens{1}{1};
    % 解析时区
    timezoneSign = timezoneStr(1);
    timezone = str2double(timezoneStr(2:3));% "08" from "+08:00"
    if timezoneSign == '-'
        timezone = -timezone;
    end
    
    % 调整开始时间和结束时间的时区
    startTimeStr = datestr(datetime(startTimeStr) - hours(timezone) + hours(default_timezone), 'HH:MM:SS');
    endTimeStr = datestr(datetime(endTimeStr) - hours(timezone) + hours(default_timezone), 'HH:MM:SS');
    
    % 解析事件描述
    events = strsplit(description, ' + ');
    
    % 解析事件时间和大概标记
    totalEventTime = 0;
    numEvents = numel(events);
    eventTimes = nan(numEvents);
    approximates = nan(numEvents);
    for jj = 1:numEvents
        event = events{jj};
        
        if contains(event, '大概')
            approximate = 1;
        else
            approximate = 0;
        end
        
        pattern = '\s(\d+)\smin';
        tokens = regexp(event, pattern, 'tokens');
        if ~isempty(tokens)
            eventTime = str2double(tokens{1}{1});
            totalEventTime = totalEventTime + eventTime;% do not add NaNs
        else
            eventTime = NaN;
        end
        
        eventTimes(jj) = eventTime;
        approximates(jj) = approximate;
        
    end
    
    % 计算默认事件时间
    stTime = datetime(stDateStr)+duration(startTimeStr);
    edTime = datetime(edDateStr)+duration(endTimeStr);
    remainingTime = minutes(edTime-stTime)-totalEventTime;
    defaultEventTime = remainingTime / numEvents;
    
    % 生成新的记录
    cur_stTime = stTime;
    cur_edTime = stTime;
    for jj = 1:numEvents
        newRecord = table();
        newRecord.uuid = data.uuid{ii};
        if ~isnan(eventTimes(jj))
            newRecord.duration = eventTimes(jj);
        else
            newRecord.duration = defaultEventTime;
        end
        cur_edTime = cur_stTime + minutes(newRecord.duration);
        newRecord.start_date = datestr(stDateStr,'yyyy-mm-dd');
        newRecord.start_time = datestr(cur_stTime,'HH:MM:SS');
        newRecord.end_time = datestr(cur_edTime,'HH:MM:SS');
        newRecord.description = events{jj};
        newRecord.approximate = approximates(jj);
        

        
        % 添加新记录到新数据表
        newData = [newData; newRecord];
        fprintf('New Record %i from Old Record %i\n',jj,ii)
    end
end

% 将数据保存为CSV文件
writetable(newData, 'output.csv');
