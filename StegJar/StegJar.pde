import java.util.*;
PImage img, imgAlt;
ArrayList<Button> buttons = new ArrayList();
int planecounter = 0; // 0 = 
int plane = 0;
boolean penToggle = false;
boolean onImg = false;
boolean imgAltered = false;
int penThickness = 10;

void setup() {
  textAlign(CENTER);
  img = loadImage("stegosaurus.png");
  size(1500, 1000);
  if (img.height > img.width) {
    img.resize(750, img.height*750/img.width);
  } else {
    img.resize(img.width*750/img.height, 750);
  }
  frameRate(1000);
  
  Button left = new Button(400, 800, "left");
  Button right = new Button(1000, 800, "right");
  Button center = new Button(700, 800, "original image");
  Button pen = new Button(400, 900, "pen");
  Button save = new Button (1000, 900, "save");
  buttons.add(left);
  buttons.add(right);
  buttons.add(center);
  buttons.add(pen);
  buttons.add(save);
  background(0);
  fill(255, 0, 0); // control panel bg color
  stroke(255,0,0);
  image(img, 0, 0);
  imgAlt = img.copy();
  rect(0, 750, 1500, 250);
}

void draw() {  
  image(img, 0, 0);
  fill(255, 0, 0);
  rect(0,750, 1500, 250);
  boolean overButton = false;
  for (int i = 0; i < buttons.size() - 1; i++) {
    buttons.get(i).update();
    if (buttons.get(i).rectOver) {
      overButton = true;
    }
  }
  if (overButton && mousePressed) {
    switch (plane) {
      case 0: originalPlane(); imgAlt.updatePixels(); break;
      case 1: redPlane(planecounter); imgAlt.updatePixels(); break;
      case 2: greenPlane(planecounter); imgAlt.updatePixels(); break;
      case 3: bluePlane(planecounter); imgAlt.updatePixels(); break;
      case 4: alphaPlane(planecounter); imgAlt.updatePixels(); break;
    }
  }

  image(imgAlt, 750, 0);
  for(Button i : buttons){
    i.update();
    
    if (i.rectOver) {
      fill(i.rectHighlight);
    } else {
      fill(i.rectColor);
    }
    stroke(255);
    rect(i.rectX, i.rectY, i.rectSize, i.rectSize);
    i.displayText();
  }
  displayCounter();
  if (mouseX > 750 && mouseY < img.height && mouseX < img.width + 750 && mouseY > 0) {
    
    onImg = true;
  } else {
    onImg = false;
  }
  if(penToggle && onImg){
    //line(mouseX, mouseY, pmouseX,pmouseY);
    circle(mouseX, mouseY, penThickness);//pen tracking
  }
  
  if (mousePressed) {
    //check if on img
    if (penToggle && onImg) {
      drawPlane(penThickness);
      loadPixels();
    } else {
      drawPlane(0);
    }
  }
}

void displayCounter(){
  fill(255); // planecounter bg color
  stroke(0);
  rect(0, 750, 1500, 30);
  fill(0);
  switch (plane){
    case 0: text("Original image", 750, 775); break;
    case 1: text("Red plane " + (planecounter+1), 750, 775); break;
    case 2: text("Green plane " + (planecounter+1), 750, 775); break;
    case 3: text("Blue plane " + (planecounter+1), 750, 775); break;
    case 4: text("Alpha plane " + (planecounter+1), 750, 775); break;
  } 
}


void mousePressed() {
  if (mousePressed) {
    if (mouseButton == 37) {
      
      //penToggle button
      if (mouseY < buttons.get(3).getY() + 90 && mouseY > buttons.get(3).getY()) {
        if (mouseX < buttons.get(3).getX() + 90 && mouseX > buttons.get(3).getX()) {
          penToggle = !penToggle;
        }
      }
      
      //save
      if (mouseY < buttons.get(4).getY() + 90 && mouseY > buttons.get(4).getY()) {
        if (mouseX < buttons.get(4).getX() + 90 && mouseX > buttons.get(4).getX()) {
          save();
        }
      }
      
      //right button, INCREASES planecounter
      if (mouseY < buttons.get(0).getY() + 90 && mouseY > buttons.get(0).getY()) {
        if (mouseX < buttons.get(0).getX() + 90 && mouseX > buttons.get(0).getX()) {
          if(plane == 0){
            plane = 4;
            planecounter = 7;
            return;
          }
          planecounter -= 1;
          if (planecounter < 0) {
            planecounter = 7;
            plane -= 1;
            if (plane < 0){
              plane = 4;
            }
          }
          //print(planecounter);
        }
      }
      //left button, DECREASES planecounter
      if (mouseY < buttons.get(1).getY() + 90 && mouseY > buttons.get(1).getY()) {
        if (mouseX < buttons.get(1).getX() + 90 && mouseX > buttons.get(1).getX()) {
          if(plane == 0){
            plane = 1;
            planecounter = 0;
            return;
          }
          planecounter += 1;
          if (planecounter > 7) {
            planecounter = 0;
            plane += 1;
            if (plane > 4){
              plane = 0;
            }
          }
        }
      }
      // original img/ center button, planecounter = 0, plane = 0
      if (mouseY < buttons.get(2).getY() + 90 && mouseY > buttons.get(2).getY()) {
        if (mouseX < buttons.get(2).getX() + 90 && mouseX > buttons.get(2).getX()) {
          plane = 0;
          planecounter = 0;
        }
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  if (event.getCount() > 0) {
    penThickness += 1;
  } else {
    if (event.getCount() < 0) {
      penThickness -= 1;
    }
  }
}
    

void originalPlane(){
  loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      int i = x + y*img.width;
      imgAlt.pixels[i] = color( red(img.pixels[i]) , green(img.pixels[i]) , blue(img.pixels[i]) );
    }
  }
}

void redPlane(int plane) {
  loadPixels();
  int digit = (int) Math.pow(2, plane);
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      int i = x + y*img.width;
      int r = (int) red(img.pixels[i]) & digit;
      imgAlt.pixels[i] = color(r / digit * 255);
    }
  }
}

void greenPlane(int plane) {
  loadPixels();
  int digit = (int) Math.pow(2, plane);
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      int i = x + y*img.width;
      int g = (int) green(img.pixels[i]) & digit;
      imgAlt.pixels[i] = color(g / digit * 255);
    }
  }
}

void bluePlane(int plane) {
  loadPixels();
  int digit = (int) Math.pow(2, plane);
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      int i = x + y*img.width;
      int b = (int) blue(img.pixels[i]) & digit;
      imgAlt.pixels[i] = color(b / digit * 255);
    }
  }
}

void alphaPlane(int plane) {
  loadPixels();
  int digit = (int) Math.pow(2, plane);
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      int i = x + y*img.width;
      int a = (int) alpha(img.pixels[i]) & digit;
      imgAlt.pixels[i] = color(a / digit * 255);
    }
  }
}

void drawPlane(int thickness) { //thickness radius
  //setting boundaries
  int leftX = mouseX - thickness / 2;
  int upY = mouseY - thickness / 2;
  int rightX = mouseX + thickness / 2;
  int downY = mouseY + thickness / 2;
  if (leftX < 750) {
    leftX = 750;
  }
  if (upY < 0) {
    upY = 0;
  }
  if (rightX > 750 + img.width - 1) {
    rightX = 750 + img.width - 1;
  }
  if (downY > img.height - 1) {
    downY = img.height - 1;
  }
  loadPixels();
  for (int x = leftX; x < rightX; x++) {
    for (int y = upY; y < downY; y++) {
      if (Math.pow(x - mouseX, 2) + Math.pow(y - mouseY, 2) < Math.pow(thickness / 2, 2)) {
        imgAlt.pixels[x - 750 + y*imgAlt.width] = color(0);
        int i = x + y*img.width;
        switch (plane) {
          case 0: img.pixels[i] = color(0); break;
          case 1: img.pixels[i] = color((((int)red(img.pixels[i]) / (int)Math.pow(2, planecounter + 1)) * (int)Math.pow(2, planecounter + 1)) + (int)red(img.pixels[i]) % (int)Math.pow(2, planecounter), green(img.pixels[i]), blue(img.pixels[i]), alpha(img.pixels[i])); break;
          case 2: img.pixels[i] = color(red(img.pixels[i]), (((int)green(img.pixels[i]) / (int)Math.pow(2, planecounter + 1)) * (int)Math.pow(2, planecounter + 1)) + (int)green(img.pixels[i]) % (int)Math.pow(2, planecounter), blue(img.pixels[i]), alpha(img.pixels[i])); break;
          case 3: img.pixels[i] = color(red(img.pixels[i]), green(img.pixels[i]), (((int)blue(img.pixels[i]) / (int)Math.pow(2, planecounter + 1)) * (int)Math.pow(2, planecounter + 1)) + (int)blue(img.pixels[i]) % (int)Math.pow(2, planecounter), alpha(img.pixels[i])); break;
          case 4: img.pixels[i] = color(red(img.pixels[i]), green(img.pixels[i]), blue(img.pixels[i]), (((int)alpha(img.pixels[i]) / (int)Math.pow(2, planecounter + 1)) * (int)Math.pow(2, planecounter + 1)) + (int)alpha(img.pixels[i]) % (int)Math.pow(2, planecounter)); break;
        }
      }
    }
  }
  imgAlt.updatePixels();
  img.updatePixels();
}

void save() {
  img.save("stegNew.png");
}
