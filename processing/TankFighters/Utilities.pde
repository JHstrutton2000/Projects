class Utilities{ 
  private float mill, sec;
  private Boolean ran = false;
  
  float[] TestTime() {
    mill = millis() - mill;
    sec = second() - sec;
    
    float[] stats = {mill, sec};
    
    if (ran) {
      mill = 0;
      sec = 0;
      ran = false;
      
      return stats;
    }
    
    ran = true;
    return null;
  }
}
