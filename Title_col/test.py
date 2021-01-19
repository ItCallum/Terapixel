from PIL import Image
import numpy as np
import cv2
from colorthief import ColorThief
from collections import Counter
from collections import defaultdict
import re
import pandas as pd
import os

The_15_cols = ['(192, 183, 143)', '(170, 163, 128)', '(144, 137, 103)', '(133, 167, 38)', '(96, 83, 49)', '(237, 234, 210)', '(220, 88, 37)', '(213, 200, 158)', '(156, 130, 125)', '(128, 126, 121)', '(112, 106, 83)', '(61, 98, 25)', '(54, 56, 40)', '(23, 26, 13)', '(13, 0, 149)']
b_test = []
## https://docs.opencv.org/3.0-beta/doc/py_tutorials/py_ml/py_kmeans/py_kmeans_opencv/py_kmeans_opencv.html

def orginal_into_k(k):

    img = cv2.imread("Capture3.PNG")

    Z = img.reshape((-1, 3))
        # convert to np.float32
    Z = np.float32(Z)

        # define criteria, number of clusters(K) and apply kmeans()
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 1.0)
    K = k
    ret,label,center=cv2.kmeans(Z,K,None,criteria,10,cv2.KMEANS_RANDOM_CENTERS)

        # Nw convert back into uint8, and make original image
    center = np.uint8(center)

    res = center[label.flatten()]

    res2 = res.reshape((img.shape))

    (cv2.imshow('res2',res2))

    cv2.imwrite("K15_map.png", res2)

    cv2.waitKey(0)
    cv2.destroyAllWindows()


def tile_class(img,name):

    #Z = img.reshape((-1, 3))
    ## convert to np.float32
    #Z = np.float32(Z)

    ## define criteria, number of clusters(K) and apply kmeans()
    #criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 1.0)
    #K = 3
    #ret,label,center=cv2.kmeans(Z,K,None,criteria,10,cv2.KMEANS_RANDOM_CENTERS)

    ## Nw convert back into uint8, and make original image
    #center = np.uint8(center)

    #res = center[label.flatten()]

    #res2 = res.reshape((img.shape))

    #(cv2.imshow('res2',res2))

    #cv2.imwrite("res2.png", res2)

    image_ = img
    colors = image_.convert('RGB').getcolors()

    regex = "\((.*?)\)"

    rgb_colours_clean = []

    for x in colors:
        test = str(x)[1:-1]
        #print(test)
        regex = "\((.*?)\)"
        a = re.search(regex, str(test))
        rgb_colours_clean.append(a.group())

    width, height = image_.size

    #print(rgb_colours_clean)

    Whats_in_the_tile = []

    for x in rgb_colours_clean:

        i = 0

        for w in range(width):
            for h in range(height):
                current_color = img.getpixel((w, h))

                if str(current_color) == str(x):
                    i = i + 1

        Whats_in_the_tile.append([str(x), i / (width * height)])

    a_test = []

    for y in The_15_cols:

        if any(y in sublist for sublist in Whats_in_the_tile):

            for x in range(len(Whats_in_the_tile)):

                if str(y) == (Whats_in_the_tile[x][0]):

                    a_test.append([y, Whats_in_the_tile[x][1]])

            #y in Whats_in_the_tile:
            #print(y)
            #a_test.append([y, Whats_in_the_tile[y][1]])

        else:
            a_test.append([y, 0])

            #print(str(y))
            #print(Whats_in_the_tile[z][0])
            #if str(y) == (Whats_in_the_tile[z][0]):
                #a_test.append([y,Whats_in_the_tile[z][1]])
            #else:
               #a_test.append([y, 0])

    b_test.append([name, a_test])
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()


def tile_class_Df(the_array):

    df = pd.DataFrame(columns=['tile', '(192, 183, 143)', '(170, 163, 128)', '(144, 137, 103)', '(133, 167, 38)', '(96, 83, 49)', '(237, 234, 210)', '(220, 88, 37)', '(213, 200, 158)', '(156, 130, 125)', '(128, 126, 121)', '(112, 106, 83)', '(61, 98, 25)', '(54, 56, 40)', '(23, 26, 13)', '(13, 0, 149)'])

    for a in range(len(the_array)):

        print(a)

        df = df.append({'tile': the_array[a][0],
                        '(192, 183, 143)': the_array[a][1][0][1],
                        '(170, 163, 128)': the_array[a][1][1][1],
                        '(144, 137, 103)': the_array[a][1][2][1],
                        '(133, 167, 38)': the_array[a][1][3][1],
                        '(96, 83, 49)': the_array[a][1][4][1],
                        '(237, 234, 210)': the_array[a][1][5][1],
                        '(220, 88, 37)': the_array[a][1][6][1],
                        '(213, 200, 158)': the_array[a][1][7][1],
                        '(156, 130, 125)': the_array[a][1][8][1],
                        '(128, 126, 121)': the_array[a][1][9][1],
                        '(112, 106, 83)': the_array[a][1][10][1],
                        '(61, 98, 25)': the_array[a][1][11][1],
                        '(54, 56, 40)': the_array[a][1][12][1],
                        '(23, 26, 13)': the_array[a][1][13][1],
                        '(13, 0, 149)': the_array[a][1][14][1]}, ignore_index=True)

    return(df)

def run_it():

    i = 1

    for filename in os.listdir("C:/Users/Callum/PycharmProjects/Title_col/8_tiles"):
        print(i)
        tile_class(Image.open(("8_tiles/")+str(filename)), str(filename))
        i = i + 1

    print("Array made")
    finshed = tile_class_Df(b_test)

    print(finshed)
    print("finshed")
    finshed.to_csv("tiles_colour.csv", sep='\t')

run_it()

#['i30.png', [['(192, 183, 143)', 0.015773809523809523], ['(170, 163, 128)', 0.027083333333333334], ['(144, 137, 103)', 0.011904761904761904], ['(133, 167, 38)', 0.4955357142857143], ['(96, 83, 49)', 0.09821428571428571], ['(237, 234, 210)', 0], ['(220, 88, 37)', 0], ['(213, 200, 158)', 0.00625], ['(156, 130, 125)', 0.0005952380952380953], ['(128, 126, 121)', 0.0026785714285714286], ['(112, 106, 83)', 0.012202380952380952], ['(61, 98, 25)', 0.09136904761904761], ['(54, 56, 40)', 0.06398809523809523], ['(23, 26, 13)', 0.1744047619047619], ['(13, 0, 149)', 0]]], ['i33.png', [['(192, 183, 143)', 0.0035714285714285713], ['(170, 163, 128)', 0.011607142857142858], ['(144, 137, 103)', 0.003869047619047619], ['(133, 167, 38)', 0], ['(96, 83, 49)', 0.025892857142857145], ['(237, 234, 210)', 0], ['(220, 88, 37)', 0], ['(213, 200, 158)', 0], ['(156, 130, 125)', 0], ['(128, 126, 121)', 0.005952380952380952], ['(112, 106, 83)', 0.013392857142857142], ['(61, 98, 25)', 0.31607142857142856], ['(54, 56, 40)', 0.17291666666666666], ['(23, 26, 13)', 0.4467261904761905], ['(13, 0, 149)', 0]]]]


#tile_class(Image.open("K15_map.png"))

#tile_class(Image.open("8_tiles/i30.png"),"8_tiles/i30.png")
#tile_class(Image.open("8_tiles/i312.png"),"8_tiles/i312.png")
#tile_class(Image.open("8_tiles/i10.png"),"8_tiles/i10.png")
