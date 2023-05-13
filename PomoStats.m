% 绘制工作日和24小时时间分布的统计图
% Sam Z. Shan with the draft and help from ChatGPT
% May 13, 2023

% 读取CSV文件
data = readtable('output.csv');

% 将日期相关的列转换为日期格式
data.start_date = datetime(data.start_date);

% 指定日期范围和关键词
startDate = datetime('2022-09-01'); % 起始日期
endDate = datetime('2023-12-31'); % 结束日期
keywords = ["吃饭"]; % 关键词

% 筛选在指定日期范围内包含指定关键词的记录
filteredData = data(data.start_date >= startDate & data.start_date <= endDate & contains(data.description, keywords), :);

% 统计每个工作日的事件总时间
workdays = unique(weekday(filteredData.start_date));
workdayTotalTime = zeros(length(workdays), 1);

for i = 1:length(workdays)
    workday = workdays(i);
    workdayData = filteredData(weekday(filteredData.start_date) == workday, :);
    workdayTotalTime(i) = sum(workdayData.duration);
end
% 星期几刻度标签
dayLabels = {'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'};

% 统计每个小时的事件数量并生成事件时间分布直方图
eventHours = hours(filteredData.start_time);
eventTimeDistribution = histcounts(eventHours, 0:24);
% 创建一个包含两个子图的 figure
figure('Position', [100, 100, 800, 400]);

% 工作日的事件总时间分布子图
subplot(1, 2, 1);
bar(workdays, workdayTotalTime);
xlabel('工作日');
ylabel('事件总时间（分钟）');
title('工作日的事件总时间分布');
grid on;
xticks(workdays);
xticklabels(dayLabels(workdays));
set(gca, 'FontSize', 12); % 设置子图的字号

% 24小时的事件时间分布直方图子图
subplot(1, 2, 2);
bar(0:23, eventTimeDistribution);
xlabel('小时');
ylabel('事件数量');
title('24小时的事件时间分布');
grid on;
set(gca, 'FontSize', 12); % 设置子图的字号

% 调整整个 figure 的字号
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14);

% 调整整个 figure 的大小
set(gcf, 'Position', [100, 100, 800, 400]);