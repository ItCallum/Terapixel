
heat_util_gpuUtilPerc <- gpu_df %>% group_by(gpuUtilPerc) %>%  summarize(min = min(gpuTempC) , qt1 = quantile(gpuTempC, 1/4), mean = mean(gpuTempC), median =  median(gpuTempC), qt3 = quantile(gpuTempC, 3/4), max =max(gpuTempC), sd = sd(gpuTempC) )


heat_util_gpuMemUtilPerc <- gpu_df %>% group_by(gpuMemUtilPerc) %>%  summarize(min = min(gpuTempC) , qt1 = quantile(gpuTempC, 1/4), mean = mean(gpuTempC), median =  median(gpuTempC), qt3 = quantile(gpuTempC, 3/4), max =max(gpuTempC), sd = sd(gpuTempC) )