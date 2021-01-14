
time_sumary <- na.omit(times) %>% group_by(eventName) %>% summarize(min = min(diff) , qt1 = quantile(diff, 1/4), mean = mean(diff), median =  median(diff), qt3 = quantile(diff, 3/4), max =max(diff), sums = sum(diff))
time_sumary_omit_totalrender <- time_sumary %>% filter(eventName != "TotalRender") %>% mutate(percenatge = sums / sum(sums) * 100)

time_sumary_12 <- na.omit(times) %>% filter(jobId == "1024-lvl12-7e026be3-5fd0-48ee-b7d1-abd61f747705") %>% group_by(eventName) %>% summarize(min = min(diff) , qt1 = quantile(diff, 1/4), mean = mean(diff), median =  median(diff), qt3 = quantile(diff, 3/4), max =max(diff), sums = sum(diff))
time_sumary_12 <- time_sumary_12 %>% mutate(percenatge = sums / sum(sums) * 100)

time_sumary_8 <- na.omit(times) %>% filter(jobId == "1024-lvl8-5ad819e1-fbf2-42e0-8f16-a3baca825a63") %>% group_by(eventName) %>% summarize(min = min(diff) , qt1 = quantile(diff, 1/4), mean = mean(diff), median =  median(diff), qt3 = quantile(diff, 3/4), max =max(diff), sums = sum(diff))
time_sumary_8 <- time_sumary_8 %>% mutate(percenatge = sums / sum(sums) * 100)

time_sumary_4 <- na.omit(times) %>% filter(jobId == "1024-lvl4-90b0c947-dcfc-4eea-a1ee-efe843b698df") %>% group_by(eventName) %>% summarize(min = min(diff) , qt1 = quantile(diff, 1/4), mean = mean(diff), median =  median(diff), qt3 = quantile(diff, 3/4), max =max(diff), sums = sum(diff))
time_sumary_4 <- time_sumary_4 %>% mutate(percenatge = sums / sum(sums) * 100)

How_long_per_task <- last_tasks %>% summarize(min = min(total_time) , qt1 = quantile(total_time, 1/4), mean = mean(total_time), median =  median(total_time), qt3 = quantile(total_time, 3/4), max =max(total_time), sums = sum(total_time))

How_long_per_task_job <- last_tasks %>% group_by(jobId) %>% summarize(min = min(total_time) , qt1 = quantile(total_time, 1/4), mean = mean(total_time), median =  median(total_time), qt3 = quantile(total_time, 3/4), max =max(total_time), sums = sum(total_time))