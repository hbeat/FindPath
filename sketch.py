#!/usr/bin/python
import tkinter as tk
import csv
import subprocess
from random import random
from astar import *
from picamera import PiCamera
from time import sleep
class Node(object):
    def __init__(self, i, j, wall = False):
        self.i = i
        self.j = j
        self.x = i*pixel + pixel//2
        self.y = j*pixel + pixel//2

        self.f = 0
        self.g = 0
        self.h = 0

        self.neighbors = []
        self.previous = None
        self.wall = False

        if wall:
            self.wall = True

    def setWall(self, w):
        self.wall = w

    def show(self, **kwargs):
        if not self.wall:
            c.create_rectangle(self.i*pixel,
                               self.j*pixel,
                               self.i*pixel + pixel,
                               self.j*pixel + pixel,
                               **kwargs)
        else:
            c.create_rectangle(self.i*pixel,
                               self.j*pixel,
                               self.i*pixel + pixel,
                               self.j*pixel + pixel,
                               fill='black')

    def draw_line(self, **kwargs):
        if self.previous:
            c.create_line(self.previous.x,
                          self.previous.y,
                          self.x,
                          self.y,
                          **kwargs)


    def addNeighbors(self):
        i = self.i
        j = self.j
        if i < rows - 1:
            self.neighbors.append(grid[i+1][j])
            if j > 0: self.neighbors.append(grid[i+1][j-1])
            if j < cols - 1: self.neighbors.append(grid[i+1][j+1])
        if i > 0:
            self.neighbors.append(grid[i-1][j])
            if j > 0: self.neighbors.append(grid[i-1][j-1])
            if j < cols - 1: self.neighbors.append(grid[i-1][j+1])
        if j < cols - 1: self.neighbors.append(grid[i][j+1])
        if j > 0: self.neighbors.append(grid[i][j-1])

    def getNeighbors(self):
        if len(self.neighbors) > 0:
            return self.neighbors
        else:
            self.addNeighbors()
            return self.neighbors

def findPath(Astar, src, dst):
	takePhoto()
	processImage()
    while True:
        ret = Astar.step(showoc = showoc)
        Astar.backtrack()
        src.show(fill='blue')
        dst.show(fill='green')
        if ret:
            break
        c.update()
        
def takePhoto():
    photoPath = '/home/pi/Destop/image.jpg'
    camera = PiCamera()
    camera.resolution = (1000,1000)
    camera.start_preview()
    sleep(10)
    camera.capture(photoPath)
    camera.stop_preview()

def processImage():
    subprocess.Popen('sh sketch_201020b.sh',shell = True)
data = []
with open('path.csv') as f:
   reader = csv.reader(f, delimiter=',')
   data.append(list(reader))

data = data[0]
print(data)
    
height = len(data) * 100
width = len(data) * 100

pixel = 100

rows = height // pixel
cols = width // pixel
foundS = False
foundE = False

showoc = True

grid = [[Node(i, j) for j in range(cols)] for i in range(rows)]

for i in range(len(data)):
    for j in range(len(data[i])):
        if(data[i][j] == '' or data[i][j] == ' '):
            continue
        if(int(data[i][j]) == 1):
            grid[i][j].setWall(True)
        elif(int(data[i][j]) == 5 and not foundS):
            foundS = True
            src = grid[i][j]
        elif(int(data[i][j]) == 5 and not foundE):
            foundE = True
            dst = grid[i][j]

top = tk.Tk()


c = tk.Canvas(top, width=width, height=height)
c.pack()

for i in range(rows):
    for j in range(cols):
        if showoc:
            grid[i][j].show(fill='white')
        else:
            grid[i][j].show(fill='white', outline='')
            

Astar = AStarPathFinder(src, dst)
            
src.show(fill='blue')
dst.show(fill='green')
B = tk.Button( text ="Find", command = lambda : findPath(Astar, src, dst),
height = 5, width = 20)
B.pack(side = tk.LEFT)
tk.mainloop()











