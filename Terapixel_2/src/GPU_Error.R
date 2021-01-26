

## get the amount of time to complete a tasks
Last_task <- last_tasks %>% summarize(min = min(total_time) , qt1 = quantile(total_time, 1/4), median =  median(total_time), qt3 = quantile(total_time, 3/4), max =max(total_time), sums = sum(total_time))
Last_task_job <- last_tasks %>% group_by(jobId) %>% summarize(min = min(total_time) , qt1 = quantile(total_time, 1/4), median =  median(total_time), qt3 = quantile(total_time, 3/4), max =max(total_time), sums = sum(total_time))


## Get the summary of time for each GPU 
link_gpu_task_12 <- link_gpu_task %>% filter(jobId == "1024-lvl12-7e026be3-5fd0-48ee-b7d1-abd61f747705")%>% group_by(gpuSerial) %>% summarize(min = min(total_time) , qt1 = quantile(total_time, 1/4), mean = mean(total_time), median =  median(total_time), qt3 = quantile(total_time, 3/4), max =max(total_time), sums = sum(total_time))

link_gpu_task_12$median <-round(link_gpu_task_12$median, digits = 0)

link_gpu_task$gpuSerial <- as.character(link_gpu_task$gpuSerial)


## Used to find out how many tasks have ran too or more jobs
link_gpu_task_table_job <- link_gpu_task %>% group_by(gpuSerial,jobId) %>% summarize(min = min(total_time) , qt1 = quantile(total_time, 1/4), mean = mean(total_time), median =  median(total_time), qt3 = quantile(total_time, 3/4), max =max(total_time), sums = sum(total_time))

## Calculate the jobs for lvl 4
lvl4_jobs <- link_gpu_task %>% filter(gpuSerial == '323617042759') %>% group_by(gpuSerial,jobId) %>% summarize(min = min(total_time) , qt1 = quantile(total_time, 1/4), mean = mean(total_time), median =  median(total_time), qt3 = quantile(total_time, 3/4), max =max(total_time), sums = sum(total_time))

## Work how much of a wait there was between each job
idle_time <- link_gpu_task %>% group_by(gpuSerial) %>% mutate(idletime = lagtime - lag(timestamp.x)) %>%  na.omit(idletime) %>% ungroup()


link_gpu_task_xy <- left_join(link_gpu_task, xy_df ,by = c("jobId","taskId") )