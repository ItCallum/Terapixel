

## Calculate a summary of how heat is effected by percent utilzation
heat_util_gpuUtilPerc <- gpu_df %>% group_by(gpuUtilPerc) %>%  summarize(min = min(gpuTempC) , qt1 = quantile(gpuTempC, 1/4), mean = mean(gpuTempC), median =  median(gpuTempC), qt3 = quantile(gpuTempC, 3/4), max =max(gpuTempC), sd = sd(gpuTempC) )

## Calculate a summary of how heat is effected by percent memory utilzation
heat_util_gpuMemUtilPerc <- gpu_df %>% group_by(gpuMemUtilPerc) %>%  summarize(min = min(gpuTempC) , qt1 = quantile(gpuTempC, 1/4), mean = mean(gpuTempC), median =  median(gpuTempC), qt3 = quantile(gpuTempC, 3/4), max =max(gpuTempC), sd = sd(gpuTempC) )

## Calculate a summary of tempratuer is effected by time
Render_time_temp <- gpu_render_highlight %>% mutate(render_time = round(render_time,digits = 0 )) %>% group_by(render_time)  %>% summarize(min = min(gpuTempC.x) , qt1 = quantile(gpuTempC.x, 1/4), mean = mean(gpuTempC.x), median =  median(gpuTempC.x), qt3 = quantile(gpuTempC.x, 3/4), max =max(gpuTempC.x), sums = sum(gpuTempC.x))

## combined render highlights with the gpu_render_highlight but grouped by render task
dat <- inner_join(gpu_render_highlight , gpu_render_highlight%>% group_by(taskId_event) %>% count(taskId_event), by = "taskId_event")

options(scipen=999)

## calculate how far through a task each tick is.
with_percentage <- dat %>% group_by(taskId_event) %>% mutate(rendering_percenatge = (row_number() / n ) * 100)
## round render time
with_percentage$render_time <- round(with_percentage$render_time, digits = 0)

## Calculate a summary the heat used at each percentage
Power_used_at_heat <- with_percentage  %>% filter(render == 1) %>% mutate(rendering_percenatge = round(rendering_percenatge,digits = 0)) %>% group_by(render_time, rendering_percenatge) %>% summarize(min = min(gpuTempC.x) , qt1 = quantile(gpuTempC.x, 1/4), mean = mean(gpuTempC.x), median =  median(gpuTempC.x), qt3 = quantile(gpuTempC.x, 3/4), max =max(gpuTempC.x), sd = sd(gpuTempC.x) )

## a graph of how temp is effected by memory ulti
Temp_memory <- ggplot(heat_util_gpuMemUtilPerc, aes(gpuMemUtilPerc,median)) + geom_line()  + geom_point() + geom_errorbar(aes(ymin=qt1, ymax=qt3), width=0.25) + ggtitle("How is tempreture effected by Memory utlisation")+ ylab("Tempreture median (Celsius)") 

##a graph of how temp effects gpu utlization
Temp_gpu <- ggplot(heat_util_gpuUtilPerc, aes(gpuUtilPerc,median)) + geom_line()  + geom_point() + geom_errorbar(aes(ymin=qt1, ymax=qt3), width=0.25) + ggtitle("How is tempreture effected by GPU utlisation")+ ylab("Tempreture median (Celsius)") 

##a graph of how temp is effected by render time
Temp_rend <-ggplot(Render_time_temp %>% filter(render_time > 0), aes(render_time,median)) + geom_line()  + geom_point() + geom_errorbar(aes(ymin=qt1, ymax=qt3), width=0.25) + ggtitle("How tempreture is effected by Render time")+ ylab("Tempreture median (Celsius)") + xlab("Render Time (Secounds)")

## cooerlation of how gpu values is effected by render time 
gpu_corr <- ggcorrplot(cor(gpu_render_highlight %>% filter(render == 1) %>% select(powerDrawWatt.x, gpuTempC.x, gpuUtilPerc.x, gpuMemUtilPerc.x,render_time))
           , hc.order = TRUE, type = "lower",
           outline.col = "white") + ggtitle("Correlation between GPU variables ")