% 为每一个指定关键词计算总时间
% Sam Z. Shan with the draft and help from ChatGPT
% May 13, 2023
% 读取CSV文件
data = readtable('output.csv');

% 指定关键词
keywords = ["Study","Work"];

% 初始化关键词总时间映射
keywordTotalTime = containers.Map('KeyType', 'char', 'ValueType', 'double');
for k = 1:length(keywords)
    keywordTotalTime(char(keywords(k))) = 0;
end

% 遍历每一行记录
for ii = 1:size(data, 1)
    description = data.description{ii};
    
    % 遍历每个关键词
    for k = 1:length(keywords)
        keyword = char(keywords(k));
        
        % 检查记录中是否包含关键词
        if contains(description, keyword)
            % 计算事件的持续时间并累加到关键词总时间
            eventDuration = data.duration(ii);
            keywordTotalTime(keyword) = keywordTotalTime(keyword) + eventDuration;
        end
    end
end

%% 显示每个关键词的总时间
for k = 1:length(keywords)
    keyword = char(keywords(k));
    fprintf(['关键词 "' keyword '" 的事件总时间为: %.2f min\n'], keywordTotalTime(keyword));
end
