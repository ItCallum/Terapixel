
## Create a summary for powerDrawWatt.x for all rendering events 
gpu_render_highlight_sum <- gpu_render_highlight %>% group_by(render)  %>%  summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x) )

## Create a summary for powerDrawWatt.x for all rendering events  but by jobs
gpu_render_highlight_sum_jobId <- gpu_render_highlight %>% group_by(render,jobId)  %>%  summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x) )

## turn render into a factor
gpu_render_highlight$render <- as.factor(gpu_render_highlight$render)

## A box plot of power usage in rendering and non rendering events
Typ_power_V_render <- ggplot(gpu_render_highlight, aes(x = render, y = powerDrawWatt.x)) + geom_boxplot() + ggtitle("Power used per tick whilist GPU is rendering vs all other events")+ ylab("Power usage in watts") 

## Code used to investergate a single host power useage over 20 minuets
single_host <- gpu_render_highlight %>% filter(hostname == '04dc4e9647154250beeee51b866b0715000000')
single_host_plot <- ggplot(single_host %>% filter(timestamp < as.POSIXct("2018-11-08 08:00:00")), aes(timestamp, powerDrawWatt.x)) + geom_line() + geom_point(aes(col = render)) + ggtitle("Power usage time line for hostname 04dc4e9647154250beeee51b866b0715000000") +ylab("Power usage in watts") 


## Code used to calucate how far through a rendering task each row was and give it a percentage value of completion
dat <- inner_join(gpu_render_highlight , gpu_render_highlight%>% group_by(taskId_event) %>% count(taskId_event), by = "taskId_event")
with_percentage <- dat %>% group_by(taskId_event) %>% mutate(rendering_percenatge = (row_number() / n ) * 100)
#with_percentage  %>% filter(render == 1) %>% group_by(render_time, rendering_percenatge) %>%  summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x) )


## Work out power used at each percentage - All render times
Power_used_at <- with_percentage  %>% filter(render == 1) %>% mutate(rendering_percenatge = round(rendering_percenatge,digits = 0)) %>% group_by(rendering_percenatge) %>% summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x) )

## Work out power used at each percentage - Sperate by render times
Power_used_at_percent <- with_percentage %>% mutate(render_time = round(render_time,digits = 0)) %>% filter(render == 1) %>% group_by(render_time, rendering_percenatge) %>%  summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x) )

## Calaculate the median powerDrawWatt.x for each render time 
gpu_render_highlight_table <- gpu_render_highlight %>% filter(render == 1)

gpu_render_highlight_table$render_time <- round(gpu_render_highlight_table$render_time, digits = 0 )

gpu_render_highlight_table <- gpu_render_highlight_table  %>% group_by(render_time)  %>%  summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x))


#gpu_render_highlight_table <- gpu_render_highlight %>% filter(render == 1)
#gpu_render_highlight_table$render_time <- round(gpu_render_highlight_table$render_time, digits = 0 )
#gpu_render_highlight_table <- gpu_render_highlight_table  %>% group_by(render_time)  %>%  summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x))


## Calaculate the median gpuUtilPerc.x for each render time
gpu_render_utlisation_sum <- gpu_render_highlight %>% filter(render == 1)

gpu_render_utlisation_sum$render_time <- round(gpu_render_utlisation_sum$render_time, digits = 0 )

gpu_render_utlisation_sum <-  gpu_render_utlisation_sum  %>% group_by(render_time)  %>% summarize(min = min(gpuUtilPerc.x) , qt1 = quantile(gpuUtilPerc.x, 1/4), median =  median(gpuUtilPerc.x), qt3 = quantile(gpuUtilPerc.x, 3/4), max =max(gpuUtilPerc.x))



## Needed to calculate the median sum of power used in each render time
gpu_render_highlight_sum <- gpu_render_highlight %>% filter(render == 1)
gpu_render_highlight_sum$render_time <- round(gpu_render_highlight_sum$render_time, digits = 0 )
gpu_render_highlight_sum <- gpu_render_highlight_sum  %>% group_by(render_time,taskId_event)  %>%  summarize(sum = sum(powerDrawWatt.x))
gpu_render_highlight_sum <-  gpu_render_highlight_sum  %>% group_by(render_time)  %>% summarize(min = min(sum) , qt1 = quantile(sum, 1/4), mean = mean(sum), median =  median(sum), qt3 = quantile(sum, 3/4), max =max(sum), sd = sd(sum))


## Code needed to create a heatmap by joining each GPU tasks to it appropriate cords.
gpu_renders_table <- gpu_render_highlight %>% filter(render == 1)
gpu_renders_xy <- left_join(gpu_renders_table, xy_df ,by = c("jobId","taskId") )

## Create a df of all of the power usages per title so we can use the median to fill in the heatmap
gpu_renders_xy_table <- gpu_renders_xy %>% mutate(render_time = round(render_time,digits = 0))  %>% group_by(render_time)  %>%  summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x),x = x,y=y, level =level)

