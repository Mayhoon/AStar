static final int RECT_SIZE = 80;

class Rect {
  private int x, y;
  private int arrX, arrY;
  private int gCost = 0;//top left
  private int hCost = 0;//top right
  private int fCost = 0; //middle
  private int type = 0;
  private boolean draw = false;
  
  Rect() {
    
  }
  
  Rect(int x, int y) {
     this.arrX = x;
     this.arrY = y;
     this.x = x * RECT_SIZE;
     this.y = y * RECT_SIZE;
  }
   
  Rect(int x, int y, int type) {
    this(x,y);
    this.type=type;
  }
  
  boolean clicked(int x, int y) {     
   if(x > this.x && x < this.x + RECT_SIZE) {
      if(y > this.y && y < this.y + RECT_SIZE) {
        return true;
      }
   }
   return false;
  }
  
  void draw() {
    switch(type) {
      case 0: fill(#FCFCFC); break;//0 = unset/default (white)
      case 1: fill(#439DE5); break;//1 = start (blue)
      case 2: fill(#ED1866); break;//2 = path (violet)
      case 3: fill(#36362A); break;//3 = blocked (black)
      case 4: fill(#1E6DAD); break;//4 = end (dark blue)
      case 5: fill(#C6942E); break;//5 = closed (orange)
      case 6: fill(#18ED3D); break;//6 = open (green)
    }
    rect(x, y , RECT_SIZE, RECT_SIZE);
    
    //not a blocked/start/end node
    if(draw == true && type != 3 && type != 1 && type != 4) {
      fill(#2579CB);
      textSize(RECT_SIZE/4);
      text(gCost, x + RECT_SIZE/8, y + RECT_SIZE/4); //top left
      text(hCost, x + RECT_SIZE - (RECT_SIZE/5), y + RECT_SIZE/4); //top right
      text(fCost, x + RECT_SIZE/2, y + RECT_SIZE/2 + RECT_SIZE/4); //middle
    }
   
    fill(#F7F7F7);
  }
  
  JSONObject asJsonObject() {
     JSONObject json = new JSONObject();
     json.setInt("x", x);
     json.setInt("y", y);
     json.setInt("gCost", gCost);  
     json.setInt("hCost", hCost);  
     json.setInt("fCost", fCost);
     json.setInt("type", type);  
     return json;
  }
  
  public void calcCosts(Rect startNode, Rect endNode) {       
    calcgCost(startNode);
    calchCost(endNode);
    
    //Not a path
    if(this.type != 2) {
      this.type = 6;
    }  
  }
  
  void calchCost(Rect endNode) {
    int x1 = endNode.getArrayPosX(); //4
    int y1 = endNode.getArrayPosY(); //1
    
    int maxX = max(x1, arrX);
    int minX = min(x1, arrX); 
    int maxY = max(y1, arrY);
    int minY = min(y1, arrY);
   
    int diffX = maxX - minX;
    int diffY = maxY - minY;
    
    int xDiff = 0;
    int yCost;
    int xCost;
    
    if(diffY > diffX) {
       xDiff = diffY - diffX;
       xCost = abs(xDiff) * 10;
       yCost = diffX * 14;
    }else {
       xDiff = diffX - diffY; 
       xCost = abs(xDiff) * 10;
       yCost = diffY * 14;
    }
   
     int sum = xCost + yCost; 
     hCost= sum;
     fCost= sum + gCost;
  }
  
  void calcgCost(Rect startNode) {
    //left
    if(arrX < startNode.getArrayPosX() && arrY == startNode.getArrayPosY()) {
        this.gCost = 10 + startNode.getGCost();
    }
    
    //right
    if(arrX > startNode.getArrayPosX() && arrY == startNode.getArrayPosY()) {
        this.gCost = 10 + startNode.getGCost();
    }
    
    //top
    if(arrX == startNode.getArrayPosX() && arrY < startNode.getArrayPosY()) {
        this.gCost = 10 + startNode.getGCost();
    }
    
    //bottom
    if(arrX == startNode.getArrayPosX() && arrY > startNode.getArrayPosY()) {
        this.gCost = 10 + startNode.getGCost();
    }
    
    //bottomLeft
    if(arrX < startNode.getArrayPosX() && arrY > startNode.getArrayPosY()) {
        this.gCost = 14 + startNode.getGCost();
    }
    
    //bottomRight
    if(arrX > startNode.getArrayPosX() && arrY > startNode.getArrayPosY()) {
        this.gCost = 14 + startNode.getGCost();
    }
    
    //topLeft
    if(arrX < startNode.getArrayPosX() && arrY < startNode.getArrayPosY()) {
        this.gCost = 14 + startNode.getGCost();
    }
    
    //topRight
    if(arrX > startNode.getArrayPosX() && arrY < startNode.getArrayPosY()) {
        this.gCost = 14 + startNode.getGCost();
    }
  }
  
    
  public void setType(int type){
    this.type = type;
  }
  
  public int getType() {
    return type;
  }
  
  public int getArrayPosX () {
    return arrX;
  }
  
  public int getArrayPosY () {
    return arrY;
  }
  
  int getGCost() {
    return gCost;
  }
  
  int getHCost() {
    return hCost;
  }
  
   int getFCost() {
    return fCost;
  }
}
