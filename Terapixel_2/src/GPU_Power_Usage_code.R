
gpu_render_highlight_sum <- gpu_render_highlight %>% group_by(render)  %>%  summarize(min = min(powerDrawWatt.x) , qt1 = quantile(powerDrawWatt.x, 1/4), mean = mean(powerDrawWatt.x), median =  median(powerDrawWatt.x), qt3 = quantile(powerDrawWatt.x, 3/4), max =max(powerDrawWatt.x), sd = sd(powerDrawWatt.x) )


gpu_render_highlight$render <- as.factor(gpu_render_highlight$render)
