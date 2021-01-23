

## ---------------------------------------------
## The Following is images that where used 

## An image of the render map
im <- load.image('D:/Masters/Cloud/Terapixel/Terapixel_v2/Terapixel_2/graphs/Capture3.PNG')

## just a blank square that is the same pixel size of the render map image
Square <- load.image('D:/Masters/Cloud/Terapixel/Terapixel_v2/Terapixel_2/graphs/Square.PNG')

## An image of the render map Color Quantization into 15 colours 
K15_map <- load.image('D:/Masters/Cloud/Terapixel/Terapixel_v2/Terapixel_2/graphs/K15_map.PNG')



## get how long it took to render a tile and join it to the correct set of cords
rendertasks <- times %>% filter(eventName == "Render")
rendertasks<- na.omit(rendertasks)
render_with_cords <- inner_join(rendertasks , xy_df , by = "taskId")

## hight and width of the render map image
width <- dim(im)[1]
height <- dim(im)[2]


## create a name for the coordinates thats the y and x cords combined (will be used to filter out tiles from the split image) 
render_with_cords <- render_with_cords %>% mutate(cord = paste0("i",y,"_",x))

## Make a variable outside of the function
make.vr <- function( x, name ){
  assign( name, x, envir = .GlobalEnv)
}

## Creates an image base off a set of given cords

## Code based off - https://rpubs.com/issactoast/cutimage

## to_render is the list of coordinated to show
## n is the n*n grid which we need to split the map into.
## Image is the image that we want to display in the tiles
## Should be one of the following 

## im - An image of the render map

## just a blank square that is the same pixel size of the render map image

## K15_map - An image of the render map Color Quantization into 15 colours 

cords_to_image <- function(to_Render,n, image){ 
  
  ## split the image into a n by n grid
  par(mfrow=c(n,n), mar = c(0,0,0.1,0.1))
  
  ## j is y cord
  ## i is x cords
  for (j in 1:n){
    for (i in 1:n){
      
      ## give this image a name that is simi;ar to the ones we use in the to_Render function 
      vr.name <- paste0("i",  n - (j) ,"_", i - 1  )
      
      ## If this image name is in the list of ones to display
      if(vr.name %in% to_Render){
        
        ## draw the appropriate image onto the canvas (so what was in the tile on the map)
        imsub(image, (width/n)*(i-1) < x & x <  i * (width/n),
              (height/n)*(j-1) < y & y <  j * (height/n)) %>%
          make.vr(name = vr.name) %>%
          plot(main = "",
               axes = FALSE,
               #xaxt="n", yaxt="n", 
               xlab = "", ylab = "", ann = FALSE )   
      }
      ## Else set the tile to display a white square instead
      else{
        imsub(Square, (width/n)*(i-1) < x & x <  i * (width/n),
              (height/n) *(j-1) < y & y <  j * (height/n)) %>%
          make.vr(name = vr.name) %>%
          # save.image( file = paste0(vr.name,".jpg")) %>%
          plot(main ="",
               axes = FALSE,
               # xaxt="n", yaxt="n", 
               xlab = "", ylab = "", ann = FALSE )    
      }
    }
  }
}



## Work out the dominate colour in each tile
job_8_Tiles_clean <- job_8_Tiles_Render %>% mutate(y_x = str_sub(tile, 2, -5), cord = str_sub(tile, 1, -5), y = as.integer(sub("_.*", "", y_x)) , x = as.integer(sub(".*_", "", y_x )))  %>% rename(i = X , DeepShadow_Roads = X.23..26..13., light_shadow = X.54..56..40., Orange = X.220..88..37. , Inside_of_buildings = X.237..234..210., tree = X.61..98..25., roof_details = X.170..163..128., Stone_ground = X.156..130..125., Roof_Slant_Away_Sun = X.144..137..103., Roof_Slant_Face_Sun = X.213..200..158., extra_shadows = X.112..106..83. , water = X.13..0..149. , Key  = X.128..126..121., Dirt = X.96..83..49. , Grass = X.133..167..38., roof = X.192..183..143. )

job_8_most_common <- job_8_Tiles_clean[,3:17] %>% rownames_to_column() %>%gather(column, value, -rowname) %>%group_by(rowname) %>% filter(rank(-value) == 1) %>% mutate(rowname = as.integer(rowname) - 1) %>%    rename(i = rowname , dominate  = column) 

job_8_Tiles_dom <- left_join(job_8_Tiles_clean,job_8_most_common,by="i")


## A function that would split the image into a grid of N * N tiles and save each each of the tiles into a file. Used to get the files needed to pass into my python algothim to work out the percentage of each object in a file. 
save_tiles <- function(n){ 
  
  base <- (render_with_cords %>% filter(jobId.x == "1024-lvl8-5ad819e1-fbf2-42e0-8f16-a3baca825a63"))$cord
  
  cords_to_image(base,n)
  
  plot(i0_1)
  
  ## j is y cord
  ## i is x cords
  for (j in 1:n){
    for (i in 1:n){
      
      ## give this image a name
      vr.name <- paste0("i",  n - (j), "_" , i - 1  )
      
      #plot(vr.name)
      
      vr.name.png <- paste0(str(n) + "_tiles/",vr.name,".png")
      
      save.image(eval(parse(text = vr.name)), vr.name.png, quality = 1)
      
    }
  }
}



#### THE FOLLOWING IS MICS CODE THAT I WROTE BUT FOR REASONS DIDNT USE 


#job_12_Tiles_Render

#job_12_clean <- job_12_Tiles_Render %>% mutate(y_x = str_sub(tile, 2, -5), cord = str_sub(tile, 1, -5), y = as.integer(sub("_.*", "", y_x)) , x = as.integer(sub(".*_", "", y_x )))  %>% rename(i = X , DeepShadow_Roads = X.23..26..13., light_shadow = X.54..56..40., Orange = X.220..88..37. , Inside_of_buildings = X.237..234..210., tree = X.61..98..25., roof_details = X.170..163..128., Stone_ground = X.156..130..125., Roof_Slant_Away_Sun = X.144..137..103., Roof_Slant_Face_Sun = X.213..200..158., extra_shadows = X.112..106..83. , water = X.13..0..149. , Key  = X.128..126..121., Dirt = X.96..83..49. , Grass = X.133..167..38., roof = X.192..183..143. )

#job_12_most_common <- job_12_clean[,3:17] %>% rownames_to_column() %>%gather(column, value, -rowname) %>%group_by(rowname) %>% filter(rank(-value) == 1) %>% mutate(rowname = as.integer(rowname) - 1) %>%    rename(i = rowname , dominate  = column) 

#most_common %>% arrange(i)

#clean

#job_12_dom <- left_join(job_12_clean,job_12_most_common,by="i")

#job_12_dom

#job_12_dom %>%  group_by(dominate)  %>%  summarize(min = min(diff) , qt1 = quantile(diff, 1/4), mean = mean(diff), median =  median(diff), qt3 = quantile(diff, 3/4), max =max(diff), sd = sd(diff))

#ggplot(job_12_dom, aes(x, y, fill= dominate)) + 
#geom_tile()

#ggcorrplot(cor(job_12_dom %>% select(diff, roof,roof_details,Roof_Slant_Away_Sun,Grass,Dirt,Inside_of_buildings,Orange,Roof_Slant_Face_Sun,Stone_ground,Key,extra_shadows,tree,light_shadow,DeepShadow_Roads,water)), hc.order = TRUE, type = "lower", outline.col = "white")


# ## PREVIOUS TEST CODE
# 
# 
# We see that looking at the image the large square that is used to display the key for the data point meaning has been cut out has required the least amount of time to fully render. This inst surprising as its pretty much a full block of color. 
# 
# We can also clearly see that large open spaces like fields and ponds of water seem to to not take long to render either. Again this is probably due to it essentially rendering a flat image.
# 
# I would say that for the most part the rendering of the tops of buildings doesn't seem to take that much time either. 
# 
# 
# Lets says all roofs, fields and ponds (so single flat color) take less than 40 seconds to render. If we remove them we can look at the other titles a bit clear.
# 
# With those cords removed we are left with what seems to be roads, some building tops and tree fields.
# 
# I want to look at 
# 
# 
# ```{r baseline}
# 
# ggplot(render_with_cords %>% filter(level == 12, diff > 40), aes(x=x, y=y, fill= diff)) + 
#  geom_tile() + facet_wrap(~ level,scales = "free") + scale_fill_gradient(low="grey", high="blue")
# 
# ggplot(render_with_cords %>% filter(level == 12, diff > 45), aes(x=x, y=y, fill= diff)) + 
#  geom_tile() + facet_wrap(~ level,scales = "free") + scale_fill_gradient(low="grey", high="blue")
# 
# ```



# ```{r colours}
# 
# ## https://www.r-bloggers.com/2019/01/extracting-colours-from-your-images-with-image-quantization/
# 
# options(digits=2)
# 
# ## Function to get n number of colours out of your image. (optionally you can specify different colour space)
# get_colorPal <- function(im, n=5, cs="RGB"){
#   #print(cs) 
#   tmp <-im %>% image_resize("100") %>% 
#     image_quantize(max=n, colorspace=cs) %>%  ## reducing colours! different colorspace gives you different result
#     magick2cimg() %>%  ## I'm converting, becauase I want to use as.data.frame function in imager package.
#     RGBtoHSV() %>% ## i like sorting colour by hue rather than RGB (red green blue)
#     as.data.frame(wide="c") %>%  #3 making it wide makes it easier to output hex colour
#     mutate(hex=hsv(rescale(c.1, from=c(0,360)),c.2,c.3),
#            hue = c.1,
#            sat = c.2,
#            value = c.3) %>%
#     count(hex, hue, sat,value, sort=T) %>% 
#     mutate(colorspace = cs)
#   
#   return(tmp %>% select(colorspace,hex,hue,sat,value,n)) ## I want data frame as a result.
#   
# }
# 
# base <- (render_with_cords %>% filter(jobId.x == "1024-lvl8-5ad819e1-fbf2-42e0-8f16-a3baca825a63"))$cord
# 
# cords_to_image(base,16,im)
# 
# image_read(i31)
# 
# plot(i31)
# 
# test <- get_colorPal(image_read(i31))
# 
# test
# 
# test$hex
# 
# ggplot(test, aes(x = "", y = n, fill = hex)) +
#   geom_bar(width = 1, stat = "identity", color = "white") +
#   coord_polar("y", start = 0)+
#   scale_fill_manual(values = test$hex) +
#   theme_void()
# 
# 
# save.image(i31, "i31.png", quality = 1)
# 
# #png(filename="i31.png")
# #plot(i31)
# #dev.off()
# 
# 
# ```
