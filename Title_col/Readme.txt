This is the code needed to run the colour Quartization and get the percentage of each colour in a tile.

Please note that this code is pretty much hard coded to work with the K15_map.png (a screen shot of the map but with colour Quartixation performed on it). 

If you where to want to use this then a lot of work have to be done. 

Firstly a new image would need to be loaded into test.py and load a new image into map varaiable in the orginal_into_k(k)

From there that will give you a new image split that been converted into into K colours and a list of all colours.

With the new image split that into the number of tiles that you want (you could use the save_tiles function in src/render_map.R for this but will require some tweaking). With the list colours place all the RGB values into a data frame like has happened in function
tile_class_Df.

Once you have the files of all the split tile images, put the file directory into run_it this should create a df of the percenatge make up of the all the colours that appear in each tile. 

- test.py 
	The code

- K15_map.png 
	the colour Quartization map

- Capture3.png 
	the regular image of the map

- 8 tiles
	All the tiles needed to make the job lvl 8 image.




Code used to help make this 
https://docs.opencv.org/3.0-beta/doc/py_tutorials/py_ml/py_kmeans/py_kmeans_opencv/py_kmeans_opencv.html

