boolean run = false;
boolean edit = false;
boolean init = true;
int row = 12;
int col = 12;
String filename = "field.json";
Rect [][] nodes = new Rect [row][col];
JSONArray jsonArray = new JSONArray();

Rect currentNode;
Rect startNode;
Rect endNode;


void setup () {
   size(1000,1000);
   for (int c = 0; c < col; c++) {
     for (int r = 0; r < row; r++) {   
         nodes[c][r] = new Rect(c,r, 0);
     }
  }
}
 
void draw () {
   // background(50);    
   for (int c = 0; c < nodes.length; c++) {
      for (int r = 0; r < nodes.length; r++) {           
         Rect rect = nodes[c][r];
         rect.draw();
      }  
   }   
    
   if(run) {          
       if(init) {
         init = false;
         getStartAndEndNode();           
         calcCostsForNeighbours(startNode);
       }else {
         currentNode = findLowestGCostNode();
         calcCostsForNeighbours(currentNode);
       }         
   }
}
   

Rect findLowestGCostNode() {
  Rect lowestGCostNode = new Rect();
  boolean firstNodeFound = false;
  
  for (int c = 0; c < col; c++) {
     for (int r = 0; r < row; r++) { 
       Rect currentNode = nodes[c][r];         
       if(currentNode.getHCost() != 0) {               
         //all open nodes
         if(currentNode.getType() == 6 ) {    //<>//
           //first open node
           if(!firstNodeFound) {      
             lowestGCostNode = currentNode;
             firstNodeFound = true;
           }
           if(currentNode.getFCost() < lowestGCostNode.getFCost()) {             
             //if(currentNode.getHCost() < lowestGCostNode.getHCost()) {               
                //println("F:" + lowestGCostNode.getFCost());
                lowestGCostNode = currentNode;            
             //}        
           }
           if(currentNode.getFCost() == lowestGCostNode.getFCost()) {             
             if(currentNode.getHCost() < lowestGCostNode.getHCost()) {               
                //println("F:" + lowestGCostNode.getFCost());
                lowestGCostNode = currentNode;            
             }        
           }
         }     
       }
     }
  }  
  lowestGCostNode.setType(2);
  return lowestGCostNode;
}

void calcCostsForNeighbours(Rect node) {
  int x = node.getArrayPosX();
  int y = node.getArrayPosY();       
  
  int leftCol = x-1;
  int middleCol = x;
  int rightCol= x+1;
  
  //y is inverted
  int topRow = y - 1;
  int middleRow = y;
  int bottomRow = y + 1;
 
 //Top row
  if(leftCol >= 0 && topRow >= 0) {
    calcCosts(leftCol, topRow); 
  }
  if(middleCol >= 0 && topRow >= 0) { 
     calcCosts(middleCol, topRow); 
  }
  if(rightCol <= row-1 && topRow >= 0) { 
     calcCosts(rightCol, topRow);
  }
  
  //Middle row
  if(leftCol >= 0) {
    calcCosts(leftCol,middleRow);
  }
  if(rightCol <= row-1) { 
     calcCosts(rightCol,middleRow);
  }
  
  //Bottom row
  if(leftCol >= 0 && bottomRow < row) {
    calcCosts(leftCol,bottomRow);
  }
  if(middleCol >= 0 && bottomRow < row) { 
     calcCosts(middleCol,bottomRow);;  
  }
  if(rightCol <= row-1 && bottomRow < row) { 
     calcCosts(rightCol,bottomRow);
  }
}

void calcCosts (int col, int row) {
  Rect r = nodes[col][row];
  if (r.getType() != 3 && r.getType() != 4 && r.getType() != 6 && r.getType() != 2 && r.getType() != 1) {
    r.calcCosts(currentNode, endNode);
    nodes[col][row] = r;  
  }else if (r.getType() == 4) {
    println("END NODE FOUND");
    run = false;
  }
}

void edit() {
  if(edit) {
    println("Editing disabled");
    edit = false;
  } else {
    println("Editing enabled");
    edit = true;
  }
}

void getStartAndEndNode() {
   for (int c = 0; c < col; c++) {
       for (int r = 0; r < row; r++) {           
         Rect currentNode = nodes[c][r];
         if(currentNode.getType() == 1) {
             startNode = currentNode;
             this.currentNode = currentNode; 
         }
         if(currentNode.getType() == 4) {
           endNode = currentNode;
         }      
       }  
    }   
}

void run() {
  if(run) {
    println("Execution paused");
    run = false;
  }else {
    println("Continue");
    run = true;
  }
}

void saveToJson() {
  int i = 0;
  for (int c = 0; c < col; c++) {
     for (int r = 0; r < row; r++) {   
        Rect rect = nodes[c][r];
        jsonArray.setJSONObject(i, rect.asJsonObject());
         i++;
     }
  }
  saveJSONArray(jsonArray, filename);
  println("Saved to " + filename);
}

void mouseClicked() {
  if(edit) {
    for (int c = 0; c < col; c++) {
      for (int r = 0; r < row; r++) {   
         Rect rect = nodes[c][r];
         if(rect.clicked(mouseX, mouseY)) {
           if(mouseButton == LEFT) {
             rect.setType(1);
           } else if(mouseButton == CENTER) {
             rect.setType(3);
           } else if(mouseButton == RIGHT){
             rect.setType(4);
           }
         }        
       }
    }  
  }
}

void keyPressed() {
  switch (key) {
    case 'e': edit(); break;
    case 's': saveToJson(); break;
    case ' ': run(); break;
    case 'v': stepDebug(); break;
    default: break;
  }
}  

void stepDebug() {
  currentNode = findLowestGCostNode();
  calcCostsForNeighbours(currentNode);
}
