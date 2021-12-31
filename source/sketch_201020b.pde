import processing.serial.*;
PrintWriter output;

PImage img;
int m =6;
int n=6;
float[][] data = new float[m][n];

void setup(){
  size(0,0);
  background(0);
  img = loadImage("image1.jpg");//test5x10.png
  surface.setResizable(true);
  surface.setSize(img.width,img.height);
  
  output= createWriter("path.csv");
  
  noLoop();
}

void draw(){
  image(img,0,0);
  loadPixels();
  int i =0;
  for(int x=width/(n*2); x < width; x+= width/n){
    int j = 0;
    for(int y = height/(m*2); y < height; y+= height/m){
      int loc = x+y*width; //max = 995999 //min = 0
      float b = brightness(img.pixels[loc]);
      //println(saturation(img.pixels[loc]));
      color test = color(img.pixels[loc]); // blue = -6514796
      float sep = saturation(img.pixels[loc]);
      print(b,sep,test,"\n");
      
      if(sep>170.0){
              data[j][i] = 5;
              pixels[loc] = color(255);
      }
      else if(b<20.0){//sep or brightness///255.0000077=therehole
            data[j][i] = 1;
            pixels[loc] = color(255);
      }
      //else if(b>254){

      //}
      else {
           data[j][i] = 0;
           pixels[loc] = color(0);
      }
      //print(j);
      j+=1;
    }
    println();
    //println("\n"+i);
    i+=1;
  }
  println();
  String str = new String();
  for(float[] row:data){
    for(float e:row){
      str = ""+e+", ";
      output.print(str);
      print(e+" ");
    }
    println();
    output.println();
  }
  updatePixels();
  output.flush();
  output.close();
  exit();
}
void serialEvent(){

}
  //int[][] data = new int[10][10];
  //int i =0;
  //for(int x=width/20; x < width; x+= width/10){
  //  int j = 0;
  //  for(int y = 0; y < height; y+= height/10){
  //    int loc = x+y*width; //max = 995999 //min = 0
  //    float b = brightness(img.pixels[loc]);
  //    if(b> 254 && b<255.0000077){//255.0000077=therehole
  //          data[i][j] = 0;
  //    }
  //    else if(b>100){
  //            data[i][j] = 0;
  //    }
  //    else{
  //    data[i][j] = 0;
  //    }
  //    //print(j);
  //    j+=1;
  //  }
  //  //println("\n"+i);
  //  i+=1;
  //}
  //for(int []d:data){
  //  for(int a:d){
  //    print(a+" ");
  //  }
  //  println();
  //}
