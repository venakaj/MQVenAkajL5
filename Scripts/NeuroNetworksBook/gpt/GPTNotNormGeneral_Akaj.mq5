//+------------------------------------------------------------------+
//|                                            gpt_test_not_norm.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.02"
#property script_show_inputs
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#define GPT_InputBars         5
#define HistoryBars           60
#define ModelName             "gpt_not_norm_v3.net"
//+------------------------------------------------------------------+
//| External parameters for script operation                         |
//+------------------------------------------------------------------+
input string   StudyFileName  = "study_data_not_norm.csv";     // Training dataset file name
input string   OutputFileName = "loss_study_gpt_not_norm.csv"; // File name to write error dynamics
input int      BarsToLine     = 60;                            // Depth of the analyzed history
input int      NeuronsToBar   = 9;                             // Number of input layer neurons per 1 bar
input bool     UseOpenCL      = false;                         // Use OpenCL
input int      BatchSize      = 8;                            // Batch size to update the weight matrix
input double   LearningRate   = 0.000003;                        // Learning rate
input int      HiddenLayers   = 3;                             // Number of hidden layers
input int      HiddenLayer    = 128;                           // Number of neurons in one hidden layer
input double   DropoutRate    = 0.5;                           // Dropout rate
input int      Epochs         = 10000;                         // Number of wight matrix update iterations
input double   ClipValue      = 1.0;                           // Max gradient value for clipping
//+------------------------------------------------------------------+
//| Connect the neural network library                               |
//+------------------------------------------------------------------+
#include "..\..\..\Include\NeuroNetworksBook\realization\neuronnet.mqh"
//+------------------------------------------------------------------+
//| Script program start                                             |
//+------------------------------------------------------------------+
void OnStart(void)
{
    PrintFormat("Starting the training process with StudyFileName=%s, OutputFileName=%s", StudyFileName, OutputFileName);
    
    VECTOR loss_history = VECTOR::Zeros(Epochs);

    CNet net;
    if(!NetworkInitialize(net))
    {
        Print("Failed to initialize the network.");
        return;
    }
    Print("Network initialized successfully.");

    CArrayObj data;
    CArrayObj result;

    if(!LoadTrainingData(StudyFileName, data, result))
    {
        Print("Failed to load training data.");
        return;
    }
    PrintFormat("Training data loaded successfully: %d patterns", data.Total());

    if(!NetworkFit(net, data, result, loss_history))
    {
        Print("Failed during network fitting.");
        return;
    }
      
    SaveLossHistory(OutputFileName, loss_history);
    Print("Training process completed successfully.");
}
//+------------------------------------------------------------------+
//| Load training data                                               |
//+------------------------------------------------------------------+
bool LoadTrainingData(string path, CArrayObj &data, CArrayObj &result)
{
    CBufferType *pattern;
    CBufferType *target;
    int handle = FileOpen(path, FILE_READ | FILE_CSV | FILE_ANSI | FILE_SHARE_READ, ",", CP_UTF8);
    if(handle == INVALID_HANDLE)
    {
        PrintFormat("Error opening study data file: %d", GetLastError());
        return false;
    }
    PrintFormat("Study data file %s opened successfully.", path);
    
    uint next_comment_time = 0;
    enum
    {
        OutputTimeout = 250 // no more than 1 time every 250 milliseconds
    };
    while(!FileIsEnding(handle) && !IsStopped())
    {
        if(!(pattern = new CBufferType()))
        {
            PrintFormat("Error creating Pattern data array: %d", GetLastError());
            return false;
        }
        if(!pattern.BufferInit(1, NeuronsToBar * GPT_InputBars))
            return false;
        
        if(!(target = new CBufferType()))
        {
            PrintFormat("Error creating Pattern Target array: %d", GetLastError());
            return false;
        }
        if(!target.BufferInit(1, 2))
            return false;
        
        int skip = (HistoryBars - GPT_InputBars) * NeuronsToBar;
        for(int i = 0; i < NeuronsToBar * HistoryBars; i++)
        {
            TYPE temp = (TYPE)FileReadNumber(handle);
            if(i < skip)
                continue;
            pattern.m_mMatrix[0, i - skip] = temp;
        }
        
        for(int i = 0; i < 2; i++)
            target.m_mMatrix[0, i] = (TYPE)FileReadNumber(handle);
        
        if(!data.Add(pattern))
        {
            PrintFormat("Error adding training data to array: %d", GetLastError());
            return false;
        }
        
        if(!result.Add(target))
        {
            PrintFormat("Error adding result data to array: %d", GetLastError());
            return false;
        }
        
        if(next_comment_time < GetTickCount())
        {
            Comment(StringFormat("Patterns loaded: %d", data.Total()));
            next_comment_time = GetTickCount() + OutputTimeout;
        }
    }
    FileClose(handle);
    Comment(StringFormat("Patterns loaded: %d", data.Total()));
    PrintFormat("Loaded %d patterns from study data file.", data.Total());
    return true;
}

//+------------------------------------------------------------------+
//| Initializing the network architecture                            |
//+------------------------------------------------------------------+
bool CreateLayersDesc(CArrayObj &layers)
{
    layers.Clear();
    CLayerDescription *descr;

    //--- Input layer
    Print("Creating input layer...");
    if(!(descr = new CLayerDescription()))
    {
        PrintFormat("Error creating input layer CLayerDescription: %d", GetLastError());
        return false;
    }
    descr.type = defNeuronBase;
    int prev_count = descr.count = NeuronsToBar * GPT_InputBars;
    descr.window = 0;
    descr.activation = AF_NONE;
    descr.optimization = None;
    if(!layers.Add(descr))
    {
        PrintFormat("Error adding input layer: %d", GetLastError());
        delete descr;
        return false;
    }

    //--- Batch Normalization layer
    Print("Creating batch normalization layer...");
    if(!(descr = new CLayerDescription()))
    {
        PrintFormat("Error creating batch normalization layer CLayerDescription: %d", GetLastError());
        return false;
    }
    descr.type = defNeuronBatchNorm;
    descr.count = prev_count; // Use the same count as the previous layer
    descr.window = prev_count;
    descr.activation = AF_NONE;
    descr.optimization = Adam;
    descr.batch = BatchSize;
    if(!layers.Add(descr))
    {
        PrintFormat("Error adding batch normalization layer: %d", GetLastError());
        delete descr;
        return false;
    }

    //--- First Convolutional layer
    Print("Creating first convolutional layer...");
    if(!(descr = new CLayerDescription()))
    {
        PrintFormat("Error creating first convolutional layer CLayerDescription: %d", GetLastError());
        return false;
    }
    descr.type = defNeuronConv;
    prev_count = descr.count = prev_count / NeuronsToBar; // Adjust count for convolution
    descr.window = NeuronsToBar;
    int prev_window = descr.window_out = 2 * NeuronsToBar;
    descr.step = NeuronsToBar;
    descr.activation = AF_SWISH;
    descr.optimization = Adam;
    descr.activation_params[0] = 1.0;
    if(!layers.Add(descr))
    {
        PrintFormat("Error adding first convolutional layer: %d", GetLastError());
        delete descr;
        return false;
    }

    //--- Second Convolutional layer
    Print("Creating second convolutional layer...");
    if(!(descr = new CLayerDescription()))
    {
        PrintFormat("Error creating second convolutional layer CLayerDescription: %d", GetLastError());
        return false;
    }
    descr.type = defNeuronConv;
    descr.window = prev_count;  // Use the count from the previous layer
    descr.step = prev_count;  // Use the count from the previous layer
    prev_count = descr.count = prev_window;
    prev_window = descr.window_out = 8;
    descr.activation = AF_SWISH;
    descr.optimization = Adam;
    descr.activation_params[0] = 1.0;
    if(!layers.Add(descr))
    {
        PrintFormat("Error adding second convolutional layer: %d", GetLastError());
        delete descr;
        return false;
    }

    //--- GPT layer
    Print("Creating GPT layer...");
    if(!(descr = new CLayerDescription()))
    {
        PrintFormat("Error creating GPT layer CLayerDescription: %d", GetLastError());
        return false;
    }
    descr.type = defNeuronGPT;
    descr.count = BarsToLine;
    descr.window = prev_count * prev_window; // Combine count and window from previous layers
    descr.window_out = prev_window;
    descr.step = 8;  // Fixed step size
    descr.layers = 4;  // Fixed number of GPT layers
    descr.activation = AF_NONE;
    descr.optimization = Adam;
    descr.activation_params[0] = 1.0;
    if(!layers.Add(descr))
    {
        PrintFormat("Error adding GPT layer: %d", GetLastError());
        delete descr;
        return false;
    }

    //--- Hidden fully connected layers with Dropout
    for(int i = 0; i < HiddenLayers; i++)
    {
        PrintFormat("Creating fully connected layer %d with Dropout...", i + 1);
        //--- Fully connected layer
        if(!(descr = new CLayerDescription()))
        {
            PrintFormat("Error creating fully connected layer CLayerDescription: %d", GetLastError());
            return false;
        }
        descr.type = defNeuronBase;
        descr.count = HiddenLayer;
        descr.activation = AF_SWISH;
        descr.optimization = Adam;
        descr.activation_params[0] = 1.0;
        if(!layers.Add(descr))
        {
            PrintFormat("Error adding fully connected layer: %d", GetLastError());
            delete descr;
            return false;
        }

        /*/--- Dropout layer
        if(!(descr = new CLayerDescription()))
        {
            PrintFormat("Error creating Dropout layer CLayerDescription: %d", GetLastError());
            return false;
        }
        descr.type = defNeuronDropout;
        descr.activation_params[0] = DropoutRate;
        if(!layers.Add(descr))
        {
            PrintFormat("Error adding Dropout layer: %d", GetLastError());
            delete descr;
            return false;
        }*/
    }

    //--- Output layer
    Print("Creating output layer...");
    if(!(descr = new CLayerDescription()))
    {
        PrintFormat("Error creating Output layer CLayerDescription: %d", GetLastError());
        return false;
    }
    descr.type = defNeuronBase;
    descr.count = 2;  // Fixed output size
    descr.activation = AF_TANH;
    descr.optimization = Adam;
    if(!layers.Add(descr))
    {
        PrintFormat("Error adding output layer: %d", GetLastError());
        delete descr;
        return false;
    }

    Print("Network layers created successfully.");
    return true;
}

//+------------------------------------------------------------------+
//| Network initialization                                           |
//+------------------------------------------------------------------+
bool NetworkInitialize(CNet &net)
{
    Print("Initializing the network...");
    if(net.Load(ModelName))
    {
        PrintFormat("Loaded pre-trained model %s", ModelName);
        net.SetLearningRates((TYPE)LearningRate, (TYPE)0.9, (TYPE)0.999);
        net.UseOpenCL(UseOpenCL);
        net.LossSmoothFactor(BatchSize);
        return true;
    }
    CArrayObj layers;
    if(!CreateLayersDesc(layers))
    {
        Print("Failed to create network layers.");
        return false;
    }
    if(!net.Create(&layers, (TYPE)LearningRate, (TYPE)0.9, (TYPE)0.999, LOSS_MSE, 0, (TYPE)0))
    {
        PrintFormat("Error initializing network: %d", GetLastError());
        return false;
    }
    net.UseOpenCL(UseOpenCL);
    net.LossSmoothFactor(BatchSize);
    Print("Network initialized successfully.");
    return true;
}

//+------------------------------------------------------------------+
//| Network training                                                 |
//+------------------------------------------------------------------+
bool NetworkFit(CNet &net, const CArrayObj &data, const CArrayObj &result, VECTOR &loss_history)
{
    int patterns = data.Total();
    int count = -1;
    TYPE min_loss = FLT_MAX;
    
    for(int epoch = 0; epoch < Epochs; epoch++)
    {
        ulong ticks = GetTickCount64();
        int k = (int)((double)(MathRand() * MathRand()) / MathPow(32767.0, 2) * (patterns - BarsToLine - 1));
        k = fmax(k, 0);

        for(int i = 0; (i < (BatchSize + BarsToLine) && (k + i) < patterns); i++)
        {
            if(IsStopped())
            {
                PrintFormat("Network fitting stopped by user at epoch %d, iteration %d", epoch, i);
                return true;
            }
            if(!net.FeedForward(data.At(k + i)))
            {
                PrintFormat("Error in FeedForward at epoch %d, iteration %d: %d", epoch, i, GetLastError());
                return false;
            }
            if(i < BarsToLine)
                continue;
            if(!net.Backpropagation(result.At(k + i)))
            {
                PrintFormat("Error in Backpropagation at epoch %d, iteration %d: %d", epoch, i, GetLastError());
                return false;
            }
            // Apply gradient clipping
            if(!ClipGradients(net))
            {
                PrintFormat("Error during gradient clipping at epoch %d, iteration %d: %d", epoch, i, GetLastError());
                return false;
            }
        }
        net.UpdateWeights(BatchSize);
        PrintFormat("Use OpenCL: %s, epoch %d, time %.5f sec", UseOpenCL ? "Yes" : "No", epoch, (GetTickCount64() - ticks) / 1000.0);
        TYPE loss = net.GetRecentAverageLoss();
        PrintFormat("Epoch %d completed, error %.5f", epoch, loss);
        loss_history[epoch] = loss;
        if(loss < min_loss)
        {
            Comment(StringFormat("Minimal Loss %.5f", loss));
            if(net.Save(ModelName))
            {
                min_loss = loss;
                count = -1;
            }
        }
        if(count >= 1000)
        {
            PrintFormat("Early Stop");
            break;
        }
        count++;
    }
    Print("Network training completed.");
    return true;
}
//+------------------------------------------------------------------+
//| Function to clip gradients                                       |
//+------------------------------------------------------------------+
bool ClipGradients(CNet &net)
{
    int total_layers = net.GetLayersCount(); // Accès direct au nombre de couches

    for(int i = 0; i < total_layers; i++)
    {
        
        CBufferType* gradients = net.GetGradient(i);
        if(gradients == NULL)
        {
            continue;
        }

        for(uint j = 0; j < gradients.Total(); j++)
        {
            TYPE grad = gradients.At(j);
            if(grad > ClipValue)
            {
                grad = ClipValue;
            }
            else if(grad < -ClipValue)
            {
                grad = -ClipValue;
            }
            gradients.Update(j, grad);
        }
    }
    return true;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Save the history of network errors                               |
//+------------------------------------------------------------------+
void SaveLossHistory(string path, const VECTOR &loss_history)
{
    Print("Saving loss history...");
    int handle = FileOpen(OutputFileName, FILE_WRITE | FILE_CSV | FILE_ANSI, ",", CP_UTF8);
    if(handle == INVALID_HANDLE)
    {
        PrintFormat("Error creating loss file: %d", GetLastError());
        return;
    }
    for(ulong i = 0; i < loss_history.Size(); i++)
        FileWrite(handle, loss_history[i]);
    FileClose(handle);
    PrintFormat("The dynamics of the error change is saved to a file %s\\MQL5\\Files\\%s", TerminalInfoString(TERMINAL_DATA_PATH), OutputFileName);
    Print("Loss history saved successfully.");
}
//+------------------------------------------------------------------+
