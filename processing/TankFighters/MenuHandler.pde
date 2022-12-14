class MainMenu{
  //private ArrayList<UIButton> buttons;
  int state = -1;
  //int state = 6;
  int loadTargetState, loadBackState;
  boolean open = true;
  PrintWriter Writer;
  
  private int xoff = 375;
  private int yoff = 220;
  private float scale = 2;
  
  Menu Main = new Menu();
  Menu LevelCreator = new Menu();
  Menu MultiPlayer = new Menu();
  
  Menu Options = new Menu();
  Menu PlayMenu = new Menu();
  
  Menu SaveMenu = new Menu();
  Menu LoadMenu = new Menu();
  
  MainMenu(){
    Writer = createWriter("Levels/Levels.txt");
    
    for(int i=0; i<Levels.size(); i++)
      Writer.println(Levels.get(i));
    Writer.flush();
    
    int[] MainText = {165, 160};
    Main.addText("TankFighters", MainText, 70);
    Main.addButton("Play", 100, 300, 600, 100); 
    Main.addButton("Level Creator", 100, 420, 600, 100); 
    Main.addButton("Multiplayer", 100, 540, 600, 100); 
    Main.addButton("Options", 100, 660, 600, 100);
    
    ArrayList<UIButton> LVbtns = new ArrayList<UIButton>();
    
    int[] LevelCreatorText = {165, 160};
    LevelCreator.addText("Level Creator", LevelCreatorText, 70);
        
    for(int x=xoff; x<width/scale+xoff; x+=it/scale){
      for(int y=yoff; y<height/scale+yoff; y+=it/scale){
        LVbtns.add(new UIButton("", x, y, it/scale, it/scale));
        //LevelCreator.addButton("", x, y, it/scale, it/scale);
      }
    }
    
    LevelCreator.addChooser(0, 0, 0, 0, 0, LVbtns, null);
    
    LevelCreator.addButton("Back", 660, 660, 100, 100);
    LevelCreator.addButton("Save Stage", 40, 660, 250, 45);
    LevelCreator.addButton("Load Stage", 40, 660+55, 250, 45);
    
    int tSize = 20;
    int x = 125;
    int xdif = 80;
    
    int[] Colorpos = {x+50, yoff+30};
    int[] redpos = {x-xdif, yoff+80};
    int[] greenpos = {x-xdif, yoff+140};
    int[] bluepos = {x-xdif, yoff+200};
    
    LevelCreator.addRect(25, yoff, 325, 240, Constants.TabBackground);
    
    LevelCreator.addText("Color", Colorpos, tSize);
    LevelCreator.addText("Red", redpos, tSize);
    LevelCreator.addText("Green", greenpos, tSize);
    LevelCreator.addText("Blue", bluepos, tSize);
    
    LevelCreator.addTextbox("150", x, yoff+50, 200, 50);
    LevelCreator.addTextbox("150", x, yoff+110, 200, 50);
    LevelCreator.addTextbox("150", x, yoff+170, 200, 50);
    
    LevelCreator.setTextboxType(0, true);
    LevelCreator.setTextboxType(1, true);
    LevelCreator.setTextboxType(2, true);
    
    ArrayList<UIButton> btns = new ArrayList<UIButton>();
    
    float Lcx = 30;
    float Lcy = 470;
    float Loff = 5;
    
    btns.add(new UIButton(loadImage("Icons/Player.png"), Lcx+Loff, Lcy+Loff));
    btns.add(new UIButton(loadImage("Icons/Enemy.png"), Lcx+30+Loff, Lcy+Loff));
    btns.add(new UIButton(loadImage("Icons/Block.png"), Lcx+60+Loff, Lcy+Loff));
    
    LevelCreator.addChooserB(Lcx, Lcy, 100, 100, Constants.TabBackground, btns);
    
    LevelCreator.getChooser(0).setState(blockTypes.Block.ordinal());
    LevelCreator.getChooser(0).setClickMode(true);
    
    int[] MultiPlayerText = {165, 160};
    MultiPlayer.addText("MultiPlayer", MultiPlayerText, 70);
    MultiPlayer.addButton("Back", 100, 660, 600, 100);
    
    int[] optionText = {165, 160};
    Options.addText("Options", optionText, 70); 
    Options.addButton("Back", 100, 660, 600, 100);
    
    int[] PlayText = {165, 160};
    PlayMenu.addText("Tutorial", PlayText, 70);
    
    int[] SaveTitleText = {165, 160};
    SaveMenu.addText("Save Menu", SaveTitleText, 70);
    SaveMenu.addButton("Back", 75, 660, 300, 100);
    SaveMenu.addButton("Save", 425, 660, 300, 100);
    
    int[] SaveName = {120, 452};
    SaveMenu.addText("Save Name", SaveName, 20);
    SaveMenu.addTextbox("", 250, 420, 400, 50);
    
    
    int[] LoadTitleText = {215, 130};
    LoadMenu.addText("Load Menu", LoadTitleText, 70);
    LoadMenu.addButton("Back", 75, 660, 300, 100);
    LoadMenu.addButton("Load", 425, 660, 300, 100);
    LoadMenu.addButton("Delete", 655, 315, 100, 100);
    
    PImage Next = loadImage("Icons/Next.png");
    PImage Prev = loadImage("Icons/Prev.png");
    
    float LMWidth = 550;
    float LMHeight = 400;
    
    LoadMenu.addButton(Next, 655, 170);
    LoadMenu.addButton(Prev, 655, 70+LMHeight);
    
    
    ArrayList<String> LMBstrs = new ArrayList<String>();
    
    
    int maxButtons = (int)Math.ceil(LMHeight / Constants.loadButtonHeight);
    
    for(int i=0; i<Levels.size(); i++){
      LMBstrs.add(Levels.get(i));
    }
    
    LoadMenu.addChooser(100, 170, LMWidth, LMHeight, Constants.TabBackground, LMBstrs, maxButtons);
  }
  
  void update(){
     if(!open)
       return;
     if(state == -2){
       this.open = false;
       Main.setState(-1);
     }
     else if(state == -1){
       Main.update();
       state = Main.getState();
     }
     else if(state == 0){
       loadBackState = -1;
       loadTargetState = -2;
       state = 6;
     }
     else if(state == 1){//Level Editor
       LevelCreator.update();
       ButtonChooser editor = LevelCreator.getChooser(0);
       
       for(int i=0; i<blocks.size(); i++){
         Block block = blocks.get(i);
         fill(block.RED, block.GREEN, block.BLUE);
         rect(block.x/2*it+xoff, block.y/2*it+yoff, it/2, it/2);
       }
       
       float st = LevelCreator.getState();
       float sta = editor.getState();
        
       
       boolean pass = true;
       
       for(int i=0; i<blocks.size(); i++){
         if(blocks.get(i).x == (int)Math.floor(sta/10) && blocks.get(i).y == (int)(sta - Math.floor(sta/10)*10))
           pass = false;
       }
       
       if(!buttonDown && pass && mouseDown && mouseButton == LEFT){
         float RED, GREEN, BLUE;
         if(LevelCreator.getTextBoxValue(0) != "")
           RED = Float.parseFloat(LevelCreator.getTextBoxValue(0));
         else
           RED = 0;
         if(LevelCreator.getTextBoxValue(1) != "")
           GREEN = Float.parseFloat(LevelCreator.getTextBoxValue(1));
         else
           GREEN = 0;
         if(LevelCreator.getTextBoxValue(2) != "")
           BLUE = Float.parseFloat(LevelCreator.getTextBoxValue(2));
         else
           BLUE = 0;
         
         blocks.add(new Block((int)Math.floor(sta/10), (int)(sta - Math.floor(sta/10)*10), 1, 1, RED, GREEN, BLUE, LevelCreator.getChooserState(1)));
       }
       else if(mouseDown && mouseButton == RIGHT){
         for(int i=0; i<blocks.size(); i++){
            if(blocks.get(i).x == (int)Math.floor(sta/10) && blocks.get(i).y == (int)(sta - Math.floor(sta/10)*10))
              blocks.remove(i);
         }
       }
              
       if(st != -1){
         if(st == 0){
           state = -1;
         } 
         else if(st == 1){//Save
           st = -1;
           state = 5;
         }
         else if(st == 2){//Load
           st = -1;
           loadBackState = 1;
           loadTargetState = 1;
           state = 6;
         }
         LevelCreator.setState(-1); 
       }
       
       Main.setState(-1);
     }
     
     else if(state == 2){
       MultiPlayer.update();
       if(MultiPlayer.getState() != -1){
         state = MultiPlayer.getState() + 4 + LevelCreator.buttons.size() + MultiPlayer.buttons.size();
         MultiPlayer.setState(-1);
       }
       Main.setState(-1);
     }
     else if(state == 3){
       Options.update();
       if(Options.getState() != -1){
         state = Options.getState() + 4 + LevelCreator.buttons.size() + MultiPlayer.buttons.size() + Options.buttons.size();
         Options.setState(-1);
       }
       Main.setState(-1);
     }
     else if(state == 4){
       PlayMenu.update();
       if(mouseDown && !buttonDown)
         this.open = false;
     }
     else if(state == 5){//Save Menu
       SaveMenu.update();
       if(SaveMenu.getState() == 1){
           String str = SaveMenu.getTextBoxValue(0);
           boolean pass = true;
           
           for(int i=0; i<Levels.size(); i++){
             if(Levels.get(i) == str){
               pass = false;
               break;
             }
           }
           
           if(pass){
             PImage col  = createImage(int(width/it), int(height/it), RGB);
             PImage type  = createImage(int(width/it), int(height/it), RGB);
             
             for(int i=0; i<blocks.size(); i++){
               Block block = blocks.get(i);
               int t = block.getType().ordinal();
               col.set((int)block.x, (int)block.y, color(block.RED, block.GREEN, block.BLUE));
               type.set((int)block.x, (int)block.y, color(t+1, t+1, t+1));
             }
             
             if(str == "")
               str = "default";
               
             col.save("Levels/"+str+"-color.png");
             type.save("Levels/"+str+"-type.png");
             
             Writer.println(str);
             Writer.flush();
             
             Levels.add(str);
             LoadMenu.getChooser(0).addButton(str);             
           }
       }
       if(SaveMenu.getState() != -1){
         state = 1;
         SaveMenu.setState(-1);
       }
     }
     else if(state == 6){//Load Menu
       LoadMenu.update();
       Main.setState(-1);//fix prob
       
       ButtonChooser chooser = LoadMenu.getChooser(0);
         
       if(LoadMenu.getState() == 0){//back
         state = loadBackState;
       }
       else if(LoadMenu.getState() == 1){//Loading in Level!!!!
         LoadMenu.setState(-1);
         
         if(chooser.getButtonCount() > 0){
           blocks = new ArrayList<Block>();
           tanks = new ArrayList<Tank>();
           
           String name = Levels.get(LoadMenu.getChooserState(0));
           
           PImage col = loadImage("Levels/"+name+"-color.png");
           PImage type = loadImage("Levels/"+name+"-type.png");
           
           for(int x=0; x<col.width; x++){
             for(int y=0; y<col.height; y++){
               color Ccol = col.get(x, y); 
               color Ctype = type.get(x, y);
               int t = (int)red(Ctype) - 1;
               
               if(t != -1){
                 blocks.add(new Block(x, y, 1, 1, red(Ccol), green(Ccol), blue(Ccol), t));
               if(t == blockTypes.Player.ordinal() || t == blockTypes.Enemy.ordinal())
                 tanks.add(new Tank(t == blockTypes.Player.ordinal(), new PVector(x*it+it/2, y*it+it/2), red(Ccol), green(Ccol), blue(Ccol))); 
               }
             }
           }
           
           //debug
           state = loadTargetState;
         }
       }
       else if(LoadMenu.getState() == 2){//delete
         LoadMenu.setState(-1);
         
         if(chooser.getButtonCount() > 0){
           try{
             Writer = createWriter("Levels/Levels.txt");
             
             int index = chooser.getState();         
             String name = chooser.getButton(index).getText();
             
             chooser.removeButton(index);
             
             sketchFile(sketchPath(name+"-color.png")).delete();
             sketchFile(sketchPath(name+"-type.png")).delete();
             Levels.remove(index);
             
             for(int i=0; i<Levels.size(); i++)
               Writer.println(Levels.get(i));
             Writer.flush();
           }
           catch(Exception ext){
             println("There is an error while deleting:",ext);
           }
           
           chooser.Rebuild();
         }
       }
       else if(LoadMenu.getState() == 3){//Prev
         chooser.prevPage();
         LoadMenu.setState(-1);
       }
       else if(LoadMenu.getState() == 4){//Next
         chooser.nextPage();
         LoadMenu.setState(-1);
       }
       
       if(LoadMenu.getState() == 1 || LoadMenu.getState() == 0)
         LoadMenu.setState(-1);
     }
     else{
       state = -1; 
     }
  }
}

class Menu{
  private int state = -1;
  private ArrayList<String> text = new ArrayList<String>();
  private ArrayList<int[]> textpos = new ArrayList<int[]>();
  private ArrayList<Float> fontSize = new ArrayList<Float>();
  
  private ArrayList<PVector> rectPos = new ArrayList<PVector>();
  private ArrayList<PVector> rectSize = new ArrayList<PVector>();
  private ArrayList<Float> rectColor = new ArrayList<Float>();
  
  private ArrayList<PImage> images = new ArrayList<PImage>();
  private ArrayList<PVector> imagePos = new ArrayList<PVector>();
  
  private ArrayList<UIButton> buttons = new ArrayList<UIButton>();
  private ArrayList<UITextbox> textboxs = new ArrayList<UITextbox>();
  
  private ArrayList<ButtonChooser> Choosers = new ArrayList<ButtonChooser>();
  
  private color col = color(165);
  
  void setTextBoxValues(ArrayList<String> vals){
    for(int i=0; i<vals.size(); i++){
      if(i >= textboxs.size())
        return;
      textboxs.get(i).setValue(vals.get(i));
    }
  }
  
  void addChooser(float x, float y, float w, float h, float background, ArrayList<UIButton> buttons, ArrayList<Integer> pages){
    ButtonChooser Chooser = new ButtonChooser(x, y, w, h, background);
    for(int i=0; i<buttons.size(); i++){
      int num = 0;
      
      if(pages != null)
        num = pages.get(i);
        
      Chooser.addButton(buttons.get(i), num);
    }
      
    Choosers.add(Chooser);
  }
  
  void addChooserB(float x, float y, float w, float h, float background, ArrayList<UIButton> buttons){
    ButtonChooser Chooser = new ButtonChooser(x, y, w, h, background);
    for(int i=0; i<buttons.size(); i++)
      Chooser.addButton(buttons.get(i), 0);
      
    Choosers.add(Chooser);
  }
  
  void addChooser(float x, float y, float w, float h, float background, ArrayList<String> strs, int maxButtons){
    ButtonChooser chooser = new ButtonChooser(x, y, w, h, background);
    
    chooser.setMaxButtonsPerPage(maxButtons);
    
    for(int i=0; i<strs.size(); i++)
      chooser.addButton(strs.get(i));
      
    Choosers.add(chooser);
  }
  
  ButtonChooser getChooser(int index){
    return Choosers.get(index);
  }
  
  void addButton(String text, float x, float y, float w, float h){
    buttons.add(new UIButton(text, x, y, w, h)); 
  }
  
  void addButton(PImage img, float x, float y){
    buttons.add(new UIButton(img, x, y)); 
  }
  
  void addButton(UIButton btn){
    buttons.add(btn); 
  }
  
  void addRect(float x, float y, float w, float h, float Color){
    rectPos.add(new PVector(x, y));
    rectSize.add(new PVector(w, h));
    rectColor.add(Color);
  }
  
  
  void addText(String text, int[] pos, float fontSize){
    this.text.add(text);
    this.textpos.add(pos);
    this.fontSize.add(fontSize);
  }
  
  void addTextbox(String defaultValue, float x, float y, float w, float h){
     textboxs.add(new UITextbox(defaultValue, x, y, w, h));
  }
  
  void addImage(String img, PVector imagePos){
    this.images.add(loadImage(img));
    this.imagePos.add(imagePos);
  }
  
  String getTextBoxValue(int index){
    return textboxs.get(index).text;
  }
  
  int getState(){
     return state;
  }
  
  int getChooserState(int index){
    return Choosers.get(index).getState();
  }
  
  void setTextboxType(int index, boolean type){
    textboxs.get(index).numOnly = type;
  }
  
  void setState(int nstate){
    state = nstate;
  }
  
  void setBackground(float num){
    this.col = color(num);
  }
  
  void setBackground(float RED, float GREEN, float BLUE){
    this.col = color(RED, GREEN, BLUE);
  }
  
  void update(){
    background(this.col);
    
    display();
    
    for(int i=0; i<buttons.size(); i++){
      
      if(buttons.get(i).Hover()){
        buttons.get(i).background  = Constants.ButtonPressed;// 190;
        if(mouseDown && !buttonDown){
          state = i;
          buttonDown = true;
        }
        
      }
      else
        buttons.get(i).background  = Constants.ButtonReleased; //220;
    }
    
    for(int i=0; i<textboxs.size(); i++)
      textboxs.get(i).update();
    for(int i=0; i<buttons.size(); i++)
      buttons.get(i).update();
    for(int i=0; i<Choosers.size(); i++)
      Choosers.get(i).update();
  }
  
  void display(){
    //fill(0);
    
    for(int i=0; i<rectPos.size(); i++){
      fill(rectColor.get(i));
      rect(rectPos.get(i).x, rectPos.get(i).y, rectSize.get(i).x, rectSize.get(i).y);
    }
    
    for(int i=0; i<text.size(); i++){
      fill(0);
      textSize(fontSize.get(i));
      int[] pos = textpos.get(i);
      text(text.get(i), pos[0], pos[1]);
    }
    
    for(int i=0; i<images.size(); i++){
      image(images.get(i), imagePos.get(i).x, imagePos.get(i).y);
    }
  }
}

class UIButton implements UIObject{
  float x, y, w, h;
  String text;
  PImage img = null;
  
  float background = 220;
  
   UIButton(String text, float x, float y, float w, float h){
     this.x = x;
     this.y = y;
     this.w = w;
     this.h = h;
     this.text = text;
   }
   
   String getText(){
     return text;
   }
   
   UIButton(PImage img, float x, float y){
    this.img = img;
    this.x = x;
    this.y = y;
    this.w = img.width;
    this.h = img.height;
    this.text = null;
   }
   
   void update(){
     display(); 
   }
   
   void display(){
     fill(background);
     rect(x, y, w, h); 
     
     fill(0);
     textSize(20);
     if(text != null)
       text(text, x+w/2-text.length()*4.5, y+h/2+10);
     else
       image(img, x, y);
   }
   
   boolean Hover(){
     return(mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
   }
}

class UITextbox implements UIObject{
  float x, y, w, h;
  String text = "";
  
  private int textlength;
  private boolean change = false;
  private boolean numOnly = false;
  private float background;
  private String defaultValue;
  
  UITextbox(String defaultValue, float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    textlength = (int)(w * 19/200);
    if(defaultValue.length() > textlength)
      this.defaultValue = defaultValue.substring(0, defaultValue.length() - (defaultValue.length() - textlength));
    else
      this.defaultValue = defaultValue;
      
    text = this.defaultValue;
  }
  
  String getValue(){
    return text; 
  }
  
  void setValue(String value){
    text = value; 
  }
  
  void update(){
    display();
    
    if(mouseDown){
      change = Hover();
    }
    else if(change && keyDown){
      if(key == ''){
        if(text.length() <= 1)
          text = "";
        else
          text = text.substring(0, text.length() -1);
        keyDown = false;
      }
      else if(keyCode ==16 || keyCode==17 || keyCode==UP || keyCode==LEFT || keyCode==RIGHT || keyCode==DOWN){}
      else if(text.length() < textlength){
        char c = key;
        if(numOnly){
          for(int i=0; i<10; i++){
            //println(c, i, str(c).equals(str(i)));
            if(str(c).equals(str(i))){
              text += c;
              keyDown = false;
            }
          }
        }
        else{
          text += c;
          keyDown = false;
        }
      }
    }
    
    if(change)
      background = Constants.TextActive; //220;
    else
      background = Constants.TextInactive; //255;
  }
  
  void display(){
    fill(background);
    rect(x, y, w, h);
    
    textSize(15);
    fill(0);
    text(text, x + 10, y + h/2+5);
  }
  
  boolean Hover(){
     return(mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
  }
}

class ButtonChooser implements UIObject{
  private float x, y, w, h;
  private ArrayList<UIButton> buttons;
  private ArrayList<Integer> buttonPaged;
  private int state = 0;
  private float background = 150;
  private int currentPage = 0;
  private int MaxPage = 0;
  private int maxButtonsPerPage = 100;
  private boolean Drag = false;
  
  
  ButtonChooser(float x, float y, float w, float h, float background){
    this.buttons = new ArrayList<UIButton>();
    this.buttonPaged = new ArrayList<Integer>();
    
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    this.background = background;
    
  }
  
  void Rebuild(){
    ArrayList<String> btns = new ArrayList<String>();
    
    for(int i=0; i<Levels.size(); i++){
      btns.add(buttons.get(i).getText());
    }
    
    buttons = new ArrayList<UIButton>();
    buttonPaged = new ArrayList<Integer>();
    
    for(int i=0; i<btns.size(); i++){
       addButton(btns.get(i));
    }
    
    state = maxButtonsPerPage*currentPage;
  }
  
  void setState(int state){
    this.state = state;
  }
  
  void setClickMode(boolean mode){
    Drag = mode;
  }
  
  int getState(){
    return this.state;
  }
  
  void setMaxButtonsPerPage(int num){
    maxButtonsPerPage = num;
  }
  
  void setBackground(float background){
    this.background = background; 
  }
  
  UIButton getButton(int index){
    return buttons.get(index);
  }
  
  int getButtonCount(){
    return buttons.size();
  }
  
  void removeButton(){
    removeButton(buttons.size()-1);
  }
  
  void removeButton(int index){
    if(buttons.size() > 0){
      buttons.remove(index);
      buttonPaged.remove(index);
    }
  }
  
  void addButton(String str, float x, float y, float w, float h, int page){
    this.buttons.add(new UIButton(str, x, y, w, h));
    this.buttonPaged.add(page);
    
    if(page > MaxPage)
      MaxPage = page;
  }
  
  void addButton(UIButton button, int page){
    this.buttons.add(button); 
    this.buttonPaged.add(page);
    
    if(page > MaxPage)
      MaxPage = page;
  }
  
  void addButton(String str){
    int page = (int)Math.floor((buttons.size())/maxButtonsPerPage);
    this.buttons.add(new UIButton(str, x, y + Constants.loadButtonHeight*(buttons.size() - maxButtonsPerPage*(page-1))-400, w, Constants.loadButtonHeight));
    this.buttonPaged.add(page);
    
    return;
  }
  
  void addButtons(ArrayList<String> strs){
    for(int i=0; i<strs.size(); i++){
      addButton(strs.get(i)); 
    }
  }
  
  void addButtons(ArrayList<UIButton> buttons, ArrayList<Integer> pages){
    for(int i=0; i<buttons.size(); i++){
      this.buttons.add(buttons.get(i));
      this.buttonPaged.add(pages.get(i));
    }
  }
  
  void nextPage(){
    if(this.currentPage < MaxPage){
      this.currentPage++;
      state = maxButtonsPerPage*currentPage;
    }
  }
  
  void prevPage(){
    if(this.currentPage > 0){
      this.currentPage--;
      state = maxButtonsPerPage*currentPage;
    }
  }
  
  void toPage(int page){
    if(page <= MaxPage)
      this.currentPage = page; 
  }
  
  int getCurrentPage(){
    return currentPage;
  }
  
  void update(){
    Draw();
    //println(blocks.size());
    if(buttons.size() > 0){
      
      MaxPage = 0;
      for(int i=0; i<buttonPaged.size(); i++){
        int num = buttonPaged.get(i);
        if(num  > MaxPage)
          MaxPage = num;
      }
      
      if(currentPage > MaxPage)
        currentPage = MaxPage;
      
      for(int i=0; i<buttons.size(); i++){
        if(buttonPaged.get(i) == currentPage){
          UIButton btn = buttons.get(i);
          btn.update();
          
          if(this.buttons.get(i).Hover())
            this.buttons.get(i).background = 175;
          else
            this.buttons.get(i).background = 220;
          
          if(!Drag && this.buttons.get(i).Hover() && mouseDown && !buttonDown){
            state = i;
            buttonDown = true;
          }
          else if(Drag && this.buttons.get(i).Hover() && mouseDown && !buttonDown){
            state = i;
          }
          
          
        }
      }
      
      UIButton btn = buttons.get(state);
      fill(Constants.ButtonPressed, 170);
      rect(btn.x, btn.y, btn.w, btn.h);
    }
  }
  
  void Draw(){
    fill(background);
    rect(x, y, w, h);
  }
  
  
  boolean Hover(){
     return(mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
  }
}
