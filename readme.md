我使用有一些额外规则（见下文PomoParser中的例子）番茄土豆app记录了生活中几乎所有事件；
在ChatGPT的帮助下终于可以把混在一起的事件拆分开来并且做统计了😂

# PomoParser:
我导出了我在[番茄土豆网站](https://pomotodo.com/app/)的记录（[官方关于如何导出的文档](http://help.pomotodo.com/collection/54cdd84b279939bc07ea4b92/article/54537a80cbe7778760d3919e)），格式是csv；
记录包含uuid，	started_at，	ended_at，	description四列，对应某种id，开始时间，结束时间，事件描述。

写一个Matlab脚本把csv文件导入，
每一条记录按照下列规则拆分成多条记录，然后再写成另一个csv文件用于之后更多的统计操作。

**例子**：
我的description中存在一条记录包含多个事项的情况，用+分隔。
有的事项包含了消耗时间，会直接记录，如果时间不是很准确会注明“大概”
没有记录时间的事项默认平分剩余时间。
比如某一行的内容是：
        sdfsdf, 
        2023-04-13T07:43:09+08:00, 
        2023-04-13T08:33:02+08:00, 
        #Life 刷牙 大概 8 min + #Life 漱口 大概 2 min + #Life 刷B站


其中
        2023-04-13是日期，
        07:43:09是开始时间，
        08:33:02是结束时间，
        +08:00是时区，
需要分别单独拆成一列；

最后的description内容是“#Life 刷牙 大概 8 min + #Life 漱口 大概 2 min + #Life 刷B站”，
按顺序拆成
        “#Life 刷牙” ，
        “#Life 漱口”，
        和“#Life 刷B站”
三个事件;

将总共的50分钟时间拆分成8分钟，2分钟和40分钟，
从07:43:09到08:33:02分割三个事件的起止时间；
另外需要加一列“大概”用1和0记录事件的时间是否包含“大概”字样，
这三个事件的“大概”列内容为1，1，0。

# PomoStats
统计包含任意一个指定关键词的事件，绘制**指定日期范围内**的工作日和24小时时间分布的统计图。

# CalculateTotalTime
为一个列表中每一个关键词计算包含该关键词事件的总时间。

# ConvertMultipleArrivalCSVToPomoRecords.xlsx
[这个网站](https://stopwatch.online-timers.com/stopwatch-with-time-intervals)可以方便地连续记录时间和导出CSV文件
针对它的输出，我做了一个excel处理表格
只需要粘贴到指定位置，修改好标签
就可以方便地编辑和生成连续的番茄记录
