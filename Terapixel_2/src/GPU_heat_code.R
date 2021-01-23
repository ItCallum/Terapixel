
heat_util_gpuUtilPerc <- gpu_df %>% group_by(gpuUtilPerc) %>%  summarize(min = min(gpuTempC) , qt1 = quantile(gpuTempC, 1/4), mean = mean(gpuTempC), median =  median(gpuTempC), qt3 = quantile(gpuTempC, 3/4), max =max(gpuTempC), sd = sd(gpuTempC) )


heat_util_gpuMemUtilPerc <- gpu_df %>% group_by(gpuMemUtilPerc) %>%  summarize(min = min(gpuTempC) , qt1 = quantile(gpuTempC, 1/4), mean = mean(gpuTempC), median =  median(gpuTempC), qt3 = quantile(gpuTempC, 3/4), max =max(gpuTempC), sd = sd(gpuTempC) )

Render_time_temp <- gpu_render_highlight %>% mutate(render_time = round(render_time,digits = 0 )) %>% group_by(render_time)  %>% summarize(min = min(gpuTempC.x) , qt1 = quantile(gpuTempC.x, 1/4), mean = mean(gpuTempC.x), median =  median(gpuTempC.x), qt3 = quantile(gpuTempC.x, 3/4), max =max(gpuTempC.x), sums = sum(gpuTempC.x))





dat <- inner_join(gpu_render_highlight , gpu_render_highlight%>% group_by(taskId_event) %>% count(taskId_event), by = "taskId_event")

options(scipen=999)

with_percentage <- dat %>% group_by(taskId_event) %>% mutate(rendering_percenatge = (row_number() / n ) * 100)

with_percentage$render_time <- round(with_percentage$render_time, digits = 0)

Power_used_at_heat <- with_percentage  %>% filter(render == 1) %>% mutate(rendering_percenatge = round(rendering_percenatge,digits = 0)) %>% group_by(render_time, rendering_percenatge) %>% summarize(min = min(gpuTempC.x) , qt1 = quantile(gpuTempC.x, 1/4), mean = mean(gpuTempC.x), median =  median(gpuTempC.x), qt3 = quantile(gpuTempC.x, 3/4), max =max(gpuTempC.x), sd = sd(gpuTempC.x) )
