# Example preprocessing script.
options(digits.secs = 3)

## ---------------------------------------------
## The Following is the raw code for this project

## Set up the checkpoints_df
checkpoints_df <- read.csv("data/application-checkpoints.csv") 
checkpoints_df <- checkpoints_df[!duplicated(checkpoints_df), ]
checkpoints_df <- checkpoints_df %>% mutate(timestamp = as.POSIXct(timestamp,format="%Y-%m-%dT%H:%M:%OS"),date = as.Date(timestamp)  , time = format(timestamp,'%H:%M:%OS'))
checkpoints_df <- checkpoints_df  %>% arrange(timestamp)

## Set up and clean the gpu_df
gpu_df <- read.csv("data/gpu.csv")
gpu_df$gpuSerial <- as.character(gpu_df$gpuSerial) 
gpu_df <- gpu_df[!duplicated(gpu_df), ]
gpu_df <- gpu_df %>% mutate(timestamp = as.POSIXct(timestamp,format="%Y-%m-%dT%H:%M:%OS"),date = as.Date(timestamp)  , time = format(timestamp,'%H:%M:%OS'))
gpu_df <- gpu_df  %>% arrange(timestamp)

## Set up and clean the xy_df
xy_df <- read.csv("data/task-x-y.csv")
xy_df <- xy_df[!duplicated(xy_df), ]


## ------------------------------------------- 
## The following is the code to use to make the times df which is the checkpoints_df but the time between each tasks id event starting and stopping has been calculated. This information was storted to its own df 
## Due to the fact it takes about 30 minuets to calculate. I have created a new datafile

#checkpoints_df_time1 <- checkpoints_df %>% mutate(taskId_event = paste(taskId, eventName, sep =" ")) 
#checkpoints_df_time1 <- checkpoints_df_time1 %>% group_by(taskId_event) %>% arrange(timestamp)  %>% mutate(diff = timestamp - lag(timestamp))

## The following is the checkpoints_df with a new coloumthe times of how long it took each event to complete. See above for the code
times <- read.csv("data/checkpoints_df_time1.csv")
times <- times %>% mutate(timestamp = as.POSIXct(timestamp,format="%Y-%m-%d %H:%M:%OS"),date = as.Date(timestamp)  , time = format(timestamp,'%H:%M:%OS'))

## -------------------------------------------


## -------------------------------------------

## I wanted to see if any of the tasks took unreasonably long to process. To do this I decided work out the time between when the first event of the task started and when the last task of the event ended.
## As this takes a while to calculate this information I decided to store it in its own dataframe

#last_tasks <- times %>% group_by(taskId) %>% arrange(timestamp) %>% filter(row_number()==1 | row_number()==n())
#last_tasks <- last_tasks %>% group_by(taskId) %>% arrange(timestamp) %>% mutate(total_time = timestamp - lag(timestamp), lagtime = lag(timestamp))
#last_tasks <-na.omit(last_tasks) %>% ungroup()
#last_tasks <- last_tasks  %>% arrange(timestamp)
# write.csv(last_tasks, "D:/Masters/Cloud/Terapixel/CSC863_Terapixle_project/Terapixel/data/last_tasks.csv", row.names=FALSE)

last_tasks <- read.csv("data/last_tasks.csv")

## -------------------------------------------

## -------------------------------------------

## Linking the GPUs to the application-checkpoints would allow us to do work out what GPU was doing what at a given time. 
## However the only way to do this would be by linking the hostnames and then using the time the timestamp in application-checkpoints to cross refence with application-checkpoints times see what event was happening at monemt in time
## Unfortantly the GPU timestamp is every 2 secounds and most events take less than a second to complete making a complete linking difficult.

## I decide that it would be best to insted only try to work out which records in the gpu_df where linked to a rendering tasks. We have see this task takes a few seconds to complete so each rendering tasks should link to a few rows in the gpu_df.

#The following is the code to work out when the GPUs where processing a rendering task. It took about 4ish hours to run so the results where sorted into a new df

## Using df with the times taken to complete each event I selected all rendering tasks and mutated the df so that we only had 1 record for each render task that but each record had the start and stop times of that render. 
# rendertime <- times %>% filter(eventName == 'Render') %>% group_by(taskId_event) %>% mutate(last_time = lag(timestamp))
# rendertime <- na.omit(rendertime)
# rendertime <- rendertime %>% select(-"taskId_event",-"eventType",-"eventName",-"time", -"date")


## Split the gpu_df into seperate df based on hostname

# to_split <- gpu_df %>% select(-"time",)
# x <- split(to_split, to_split$hostname)

## Make an empty DF that I will be used to combined everything together.
#  df <- data.frame()


## Loop through each hostname   
#  for (i in x){
## Join the rendertime and the slice of hostname gpu_df by the hostname selected
#    dat <- inner_join(i , rendertime, by = "hostname")

## Work out if the GPU is running a render task.
#    dat <- dat %>% group_by(hostname) %>% mutate(render = as.integer(timestamp.x >= last_time & timestamp.x <= timestamp.y), render_time = ifelse(render == 1, diff, 0))
#    dat <- dat %>% filter(render == 1) %>% rename(timestamp = timestamp.x, render_start = last_time ,render_end = timestamp.y)
#    dat1 <- left_join(i, dat, by = c("timestamp","hostname"))


## If a render event is happing at that time set it to 1 else 0
#    dat1$render[is.na(dat1$render)] <- 0
#    dat1$render_time[is.na(dat1$render_time)] <- 0
#  
## Combind the results for this hostname with all the results for the other hostnames 
#    df <- rbind(df, dat1)
#  
#    df}
## Remove some unneeded data 
#  df <- df %>% select(-"date.x",-"gpuSerial.y",-"gpuUUID.y",-"powerDrawWatt.y",-"gpuTempC.y", -"gpuUtilPerc.y",-"gpuMemUtilPerc.y",-"date.y")
#  write.csv(df, "D:/Masters/Cloud/Terapixel/CSC863_Terapixle_project/Terapixel/data/gpu_render_highlight.csv", row.names=FALSE)

gpu_render_highlight <- read.csv("data/gpu_render_highlight.csv")
gpu_render_highlight$gpuSerial.x <- as.character(gpu_render_highlight$gpuSerial.x) 
gpu_render_highlight <- gpu_render_highlight %>% mutate(timestamp = as.POSIXct(timestamp,format="%Y-%m-%d %H:%M:%OS"))

## -------------------------------------------



## -------------------------------------------
## Df used to create a heat map
df_heat_map <- ddply(xy_df, .(xy_df$x, xy_df$y, xy_df$level), nrow)
names(df_heat_map) <- c("x", "y", "level", "V1")
## -------------------------------------------


## -------------------------------------------

## I wanted to link each task to link each taskID (with its time needed to complete that task) to the GPU used to completed it.  

## Like before, split the gpu_df into sperate single GPU_df 
# to_split <- gpu_df %>% select(-"time",)
# x <- split(to_split, to_split$hostname)
# 
#  df <- data.frame()
# 
#  for (i in x){

## Combind everything in the last_task (so the last event done for each task) to the GPUs on the same hostname 
#    test <- inner_join(last_tasks, i, by = "hostname")
#    test <- test %>% mutate(timestamp = as.POSIXct(timestamp.x,format="%Y-%m-%d %H:%M:%OS"),lagtime= as.POSIXct(lagtime,format="%Y-%m-%d %H:%M:%OS"),timestamp.y= as.POSIXct(timestamp.y,format="%Y-%m-%d %H:%M:%OS") )

## See if the GPU links to the task.
#    test <- test %>% mutate(Link = as.integer(timestamp.y >=  lagtime  & timestamp.y <= timestamp.x)) %>% filter(Link == 1)

## Only return one link per task
#    test <- test[!duplicated(test[,c('taskId')]),]

## Combind the results for this hostname with all the results for the other hostnames 
#    df <- rbind(df, test)
# 
#    df}
# 
#  write.csv(df, "D:/Masters/Cloud/Terapixel/CSC863_Terapixle_project/Terapixel/data/link_gpu_task.csv", row.names=FALSE)

link_gpu_task <- read.csv("data/link_gpu_task.csv")
link_gpu_task <- link_gpu_task %>% mutate(timestamp.x = as.POSIXct(timestamp.x,format="%Y-%m-%d %H:%M:%OS"),lagtime= as.POSIXct(lagtime,format="%Y-%m-%d %H:%M:%OS"))


## Just Random test code

##didItwork <- read.csv("data/checkpoints_df_time.csv")
##write.csv(checkpoints_df_time1, "D:/Masters/Cloud/Terapixel/CSC863_Terapixle_project/Terapixel/data/checkpoints_df_time1.csv", row.names=FALSE)

