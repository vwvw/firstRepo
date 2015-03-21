
//processing convention

//    -y
//    |
//    |
//    |
//    |
//    |__________ x
//   /
//  /
// /
// z





float rotVertical = 0;

//rotation that we do
float rotX = 0;
float rotZ = 0;

//the rotation that was already done
float previousrotX ;
float previousrotZ ;
//the position of the mouse at the begining of the movement
float mousePositionX;
float mousePositionY ;

//baord movementscaler
float movementScale = 1;

//ball and board attributes
float radius = 5;
float lBoard = 250;

//movement attributes
PVector gravityForce = new PVector(0, 0, 0);
float gravityConstant = 0.3;
Mover mover;


// cylinder declaration 
float cylinderBaseSize = 15; 
float cylinderHeight = 50; 
int cylinderResolution = 30;
PShape completeCylinder = new PShape();
PShape openCylinder = new PShape();
PShape cylinderTop = new PShape();
PShape cylinderBottom = new PShape();
boolean mode = false; //true = place cylinder
ArrayList<PVector> arrayCylinder = new ArrayList<PVector>();


// Cylinder array
ArrayList<PVector> Cylinders = new ArrayList<PVector>(); 


void setup() 
{
  size(500, 500, P3D); 
  noStroke();
  mover = new Mover();
  cylinderQqch(); // create the shape once and for all...
}

void draw() {
  //ambient settings

  directionalLight(50, 100, 125, 0, 1, 0); 
  ambientLight(102, 102, 102);
  background(200);




  if (mode) // place cylinder
  {
    
    camera(0, -400, 0, 0, 0, 0, 1, 1, 0);
    box(lBoard, 10, lBoard);
    pushMatrix();
    rotateX(PI/2);
    rotateZ(-PI/2);
   
    
    if((mouseX>140 && mouseX < 360) && (mouseY > 140 && mouseY < 360)) // trouve les valeurs exactes...
    {
   
      //cylinderQqch(mouseX-lBoard,mouseY-lBoard); 
        shape(completeCylinder);
    
    
    for (int i = 0; i< arrayCylinder.size (); i++)
    {
        pushMatrix();
     
//      float positionX = arrayCylinder.get(i).x-lBoard;
//      float positionY = arrayCylinder.get(i).y-lBoard;
        translate(arrayCylinder.get(i).x,0,arrayCylinder.get(i).y);
      //cylinderQqch(positionX, positionY);
        shape(completeCylinder);
       popMatrix();
    } 
    }
    
   
  } else {
    camera(250, -1, 250, width/2, height/2, 0, 0, 1, 0); 
    //we move the coodinates to have the board in the center of the window
    translate(width/2, height/2, 0);
    
    rotateZ(rotZ); 
    rotateX(-rotX);


    box(lBoard, 10, lBoard);
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = sin(rotX) * gravityConstant;

    //draw cylinder
    
   
    
    for (int i = 0; i< arrayCylinder.size (); i++)
    {
      pushMatrix();
      translate(arrayCylinder.get(i).x,0,arrayCylinder.get(i).y);
      rotateX(PI/2);
      float positionX = arrayCylinder.get(i).x-lBoard;
      float positionY = arrayCylinder.get(i).y-lBoard;
      //cylinderQqch(positionX, positionY);
      shape(completeCylinder);
      popMatrix();
    }
    


    pushMatrix();
    mover.update();
    mover.display();
    popMatrix();
    popMatrix();
  }
}

//we save the mouse position, and archive the rotation level
void mousePressed()
{
  if (mode)
  {
    // checker si la balle est pas dans le cylindre...
    PVector cyl = new PVector(mouseX, mouseY);
    arrayCylinder.add(cyl);
  } else {
    mousePositionX = mouseX;
    mousePositionY = mouseY;
    previousrotZ = rotZ;
    previousrotX = rotX;
  }
}


//when the mouse is dragged we compare the distance mouvec
void mouseDragged() 
{
  rotX = (float) (previousrotX + Math.pow(1.1, movementScale) * map(mouseY - mousePositionY, -height, height, -PI/3, PI/3)); 
  rotZ = (float) (previousrotZ + Math.pow(1.1, movementScale) * map(mouseX - mousePositionX, -width, width, -PI/3, PI/3));
  if (rotX > PI/3) rotX = PI/3; 
  if (rotX < -PI/3) rotX = -PI/3; 
  if (rotZ > PI/3) rotZ = PI/3; 
  if (rotZ < -PI/3) rotZ = -PI/3;
}



//vertical rotation with arrow keys
/*void keyPressed() { 
 if (key == CODED) {
 if (keyCode == LEFT) { 
 rotVertical -= 50;
 } else if (keyCode == RIGHT) {
 rotVertical += 50;
 }
 }
 }*/

void keyPressed() { 
  if (key == CODED) {
    if (keyCode == SHIFT) { 
      mode = !mode;
    }
  }
}


void mouseWheel(MouseEvent event) {
  movementScale -= event.getCount();
}

void cylinderQqch()
{
  //Open cylinder
  float angle;
  float[] x = new float[cylinderResolution + 1]; 
  float[] y = new float[cylinderResolution + 1];

  

  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i; 
    x[i] = sin(angle) * cylinderBaseSize ; 
    y[i] = cos(angle) * cylinderBaseSize ;
  }
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  //draw the border of the cylinder
  for (int i = 0; i < x.length; i++) { 
    openCylinder.vertex(x[i], y[i], 0); 
    openCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();
  
  cylinderTop = createShape();
  cylinderTop.beginShape(TRIANGLE_FAN);
  cylinderTop.vertex(0, 0, cylinderHeight);
  for (int i = 0; i < x.length; i++) {
    cylinderTop.vertex(x[i], y[i], cylinderHeight);
  }
  cylinderTop.vertex(x[0], y[0], cylinderHeight);
  cylinderTop.endShape();  
  
  cylinderBottom = createShape();
  cylinderBottom.beginShape(TRIANGLE_FAN);
  cylinderBottom.vertex(0, 0, 0);
  for (int i = 0; i < x.length; i++) {
    cylinderBottom.vertex(x[i], y[i], 0);
  }
  //cylinderBottom.vertex(x[0], y[0], 0); => why
  cylinderBottom.endShape();
  
  //shape(openCylinder);
  //shape(cylinderTop);
  //shape(cylinderBottom);
  //box(10); ???
    
  
   completeCylinder = createShape(GROUP);
   completeCylinder.addChild(openCylinder);
   completeCylinder.addChild(cylinderTop); 
   completeCylinder.addChild(cylinderBottom);
}

