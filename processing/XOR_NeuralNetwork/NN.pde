class NeuralNetwork {
  private float Weightrange = 10;

  private Neuron[] Neurons;
  //private float[] axons;

  private int[] Inputs;
  private int[][] Hiddens;
  private int[] Outputs;

  private float[] weights;
  private int[] weightsmap;
  public boolean loading;

  private float learningrate = 0.1;

  NeuralNetwork(int Input, int HiddenX, int HiddenY, int Output, boolean loading) {
    Inputs = new int[Input];
    Hiddens = new int[HiddenX][HiddenY];
    Outputs = new int[Output];
    Neurons = new Neuron[Input+HiddenX*HiddenY+Output];
    this.loading = loading;
    //axons = new float[Input+HiddenX*HiddenY+Output];

    int weightCount = 0;
    if (HiddenX>0)
      weightCount = Input*HiddenY + (HiddenX - 1)*HiddenY*HiddenY + HiddenY*Output;
    else if(HiddenX == 0 || HiddenY ==0)
      weightCount = Input *Output;

    weights = new float[weightCount];
    weightsmap = new int[weightCount];

    initWeights(loading);

    int y = 0;
    int Count = 0;
    float it;
    
    for (int i=0; i<Input; i++) {
      Inputs[i] = y;
      Neurons[y] = new Neuron();
      
      it = height/Input;
      
      Neurons[y].setX(Distance);
      Neurons[y].setY(it*i + it/2);
      
      y++;
    }

    for (int i=0; i<HiddenX; i++) {
      for (int v=0; v<HiddenY; v++) {
        Hiddens[i][v] = y;
        Neurons[y] = new Neuron();
        
        it = height/HiddenY;
        
        Neurons[y].setX(i*Distance+2*Distance);
        Neurons[y].setY(it*v + it/2);
        
        if (i==0) {
          for (int j=0; j<Input; j++) {
            Neurons[y].addDendrite(Neurons[j], weights[Count]);
            Count++;
          }
        } else{
          for (int j=0; j<HiddenY; j++) {
            Neurons[y].addDendrite(Neurons[Hiddens[i-1][j]], weights[Count]);
            Count++;
          }
          Count -= HiddenY;
        }
        y++;
      }
    }


    for (int i=0; i<Output; i++) {
      Outputs[i] = y;
      Neurons[y] = new Neuron();
      
      it = height/Output;
      
      Neurons[y].setX(Hiddens.length*Distance+2*Distance);
      Neurons[y].setY(it*i + it/2);
      
      if(HiddenY ==0 || HiddenX ==0){
          for (int j=0; j<Input; j++) {
            Neurons[y].addDendrite(Neurons[j], 0);
            Count++;
          }
      }
      else{
        for (int j=0; j<HiddenY; j++) {
          Neurons[y].addDendrite(Neurons[Hiddens[HiddenX-1][j]], weights[Count]);
          Count++;
        }
      }

      y++;
    }
  }

  private void initWeights(boolean loading) {
    if (loading)
      weights = loadWeights(weights.length);
    else {
      for (int i=0; i<weights.length; i++) {
        //weights[i] = 1;
        weights[i] = random(-Weightrange, Weightrange);
        if(Hiddens.length == 0){//IO
          weightsmap[i] = 2;
        }
        else{
          if (i<=Inputs.length * Hiddens[0].length-1)//IH
            weightsmap[i] = 0;
          else if (i<=Inputs.length * Hiddens[0].length + (Hiddens.length-1) * Math.pow(Hiddens[0].length, 2)-1) {//HH
            weightsmap[i] = 1;
          } else if (i<=Inputs.length * Hiddens[0].length + (Hiddens.length-1) * Math.pow(Hiddens[0].length, 2) + Hiddens[0].length*Outputs.length-1)//HO
            weightsmap[i] = 2;
        }
      }
    }
  }

  public float[] feedForward(float[] Inputs) {
    int len = this.Inputs.length;

    if (len != Inputs.length) {
      println("The inputs length is not expected value");
    }
    
    for(int i=0; i<Inputs.length; i++){
      Neurons[i].axonValue = Inputs[i]; 
    }
    
    for(int i=0; i<Hiddens.length; i++){
      for(int j=0; j<Hiddens[i].length; j++){
        Neuron n = Neurons[Hiddens[i][j]];
        if(i==0){//Input Hidden
          for(int v=0; v<Inputs.length; v++){
            n.setDendrite(v, Neurons[v]);
          }
        }
        else{//Hidden Hidden
          for(int v=0; v<Hiddens[0].length; v++){
            n.setDendrite(v, Neurons[Hiddens[i-1][v]]); 
          }
        }
        n.process();
      }
    }
    
    for(int i=0; i<Outputs.length; i++){
      Neuron n =Neurons[Outputs[i]];
      if(Hiddens.length==0){
          for(int v=0; v<Inputs.length; v++){
            n.setDendrite(v, Neurons[v]);
          }
      }
      else{
        for(int v=0; v<Hiddens[0].length; v++){
           n.setDendrite(v, Neurons[Hiddens[Hiddens.length-1][v]]);
        }
      }
      n.process();
    }

    len = this.Outputs.length;
    float[] Outputs = new float[len];

    for (int i=0; i<len; i++)
      Outputs[i] = Neurons[this.Outputs[i]].axonValue;
    
    return Outputs;
  }
  
  public float[][] feedForward(float[][][] dataset){
    float[][] out = new float[dataset.length][dataset[0][1].length];
    for (int i=0; i<dataset.length; i++) {
      out[i] = feedForward(dataset[i][0]);
      if(out[i] == null)
        out[i] = lastResult[i];
    }
    
    return out;
  }

  public void train(float[] inputs, float[] expected) {
    int len = expected.length;
    float[] result = feedForward(inputs);
    
    
    if(result == null)
      return;
    
    //while(result==null)
    //  result = feedForward(inputs);
      
    float[] OutputErrors = new float[len];
    float[][] hiddenErrors;// = new float[Hiddens.length][Hiddens[0].length];
    float[][] hiddens;// = new float[Hiddens.length][Hiddens[0].length];

    if(Hiddens.length == 0){
      hiddenErrors = new float[0][0];
      hiddens = new float[0][0];
    }
    else{
      hiddenErrors = new float[Hiddens.length][Hiddens[0].length];
      hiddens = new float[Hiddens.length][Hiddens[0].length];
    }

    for (int i=0; i<result.length; i++) {
      OutputErrors[i] = expected[i] - result[i];
      Neurons[Outputs[i]].addError(OutputErrors[i]);
      Neurons[Outputs[i]].processErrors();
    }
    
    for (int x=0; x<Hiddens.length; x++) {
      for (int y=0; y<Hiddens[x].length; y++) {
        hiddens[x][y] = Neurons[Hiddens[x][y]].axonValue;
      }
    }

    for (int x=Hiddens.length-1; x>=0; x--) {
      for (int y=0; y<Hiddens[x].length; y++) {
        if (x==Hiddens.length-1) {//Hidden Outputs
          for (int i=0; i<Outputs.length; i++) {
            Neuron output = Neurons[Outputs[i]];
            Neurons[Hiddens[x][y]].addError(OutputErrors[i] * output.getWeight(y));//error * weight
          }
        }
        else {//Hidden Hidden
          for (int i=0; i<Hiddens[x].length; i++) {
            Neuron hidden = Neurons[Hiddens[x+1][i]];
            Neurons[Hiddens[x][y]].addError(hidden.getError() * hidden.getWeight(y));
          }
        }
        Neurons[Hiddens[x][y]].processErrors();
        hiddenErrors[x][y] = Neurons[Hiddens[x][y]].getError();
      }
    }
    len = weights.length;
    
    for (int i=0; i<len; i++) {
      float nonproc = 0;
      float error = 0;
      //println(weightsmap[i]);
      if (weightsmap[i] == 1) {//Connected Hiddens, Hiddens
        int index = (i - inputs.length*hiddens[0].length);//index in current hidden hidden weights

        int x = index / (int)Math.pow(hiddens[0].length, 2);
        int y = index%hiddens[0].length;
        
        nonproc = hiddens[x][y];
        error = Neurons[Hiddens[x+1][index%hiddens[0].length]].getError();
      }
      else if (weightsmap[i] == 2) {//Connected to Outputs, Hiddens
        int index =0;
        
        if(hiddens.length ==0){
          nonproc = Neurons[Inputs[i%inputs.length]].axonValue;
          error = Neurons[Outputs[i%Outputs.length]].getError();
          //nonproc = 1;
          //error =0;
        }
        else{//hidden, output
          index = i - inputs.length*hiddens[0].length - hiddens[0].length * hiddens[0].length*(hiddens.length-1);
          nonproc = hiddens[hiddens.length-1][index%hiddens[0].length];//possible bug!!!
          //println(hiddens.length-1, index%hiddens[0].length);
          
          error = Neurons[Outputs[index/hiddens[0].length]].getError();
        }
      }

      if (weightsmap[i] == 0) {//Connected Hiddens, Inputs
        int index = i/inputs.length;

        error = Neurons[Hiddens[0][index]].getError();
        nonproc = inputs[i%inputs.length];
      }
      else {
        nonproc = nonproc *(1-nonproc);
        //nonproc = dSigmoid(nonproc);
      }
      //println(learningrate, error, nonproc);
      weights[i] += learningrate * error * nonproc;
    }

    updateWeights();
  }

  void train(float[][][] dataset) {
    for (int i=0; i<dataset.length; i++) {
      train(dataset[i][0], dataset[i][1]);
    }
  }

  private void updateWeights() {
    ArrayList<Float> ls = new ArrayList();  

    int Count = 0;
    for (int i=0; i<Neurons.length; i++) {
      ArrayList<Float> nW = new ArrayList<Float>(); 
      Neuron n = Neurons[i];

      for (int v=0; v<n.weights.size(); v++) {
        ls.add(weights[Count]);
        nW.add(weights[Count]);
        Count++;
      }
      n.setWeights(nW);
    }
  }

  private void saveWeights() {
    PrintWriter weightLog;

    weightLog = createWriter("Weights.txt");

    for (int i=0; i<weights.length; i++) {
      weightLog.println(weights[i]);
    }
    weightLog.flush();

    println("saved Network");
  }

  private float[] loadWeights(int weightCount) {
    BufferedReader weightsLog = createReader("Weights.txt");

    float[] weights_ = new float[weightCount];
    String line = null;
    int i=0;

    try {
      while ((line = weightsLog.readLine()) != null) {
        weights_[i] = float(line);
        i++;
      }
      weightsLog.close();
    }
    catch (IOException e) {
      e.printStackTrace();
    }

    return weights_;
  }
}
