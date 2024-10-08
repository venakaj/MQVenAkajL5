//+------------------------------------------------------------------+
//|                                                opencl_program.cl |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//--- by default some GPU doesn't support TYPEs
//--- cl_khr_fp64 directive is used to enable work with TYPEs
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
//+------------------------------------------------------------------+
//| Activation functions                                             |
//+------------------------------------------------------------------+
//| Linear activation function                                       |
//| Parameter 'value' Weighted sum of initial data                   |
//|           'a' defines the angle of inclination of the line       |
//|           'b' - the vertical offset of the line                  |
//+------------------------------------------------------------------+
__kernel void LineActivation(__global TYPE* inputs,
                             __global TYPE* outputs,
                             const TYPE a, const TYPE b)
  {
   size_t i = get_global_id(0);
   outputs[i] = (a * inputs[i] + b);
  }
//+------------------------------------------------------------------+
//| Sigmoid activation function                                      |
//| Parameter 'value' Weighted sum of initial data                   |
//|           'a' stretches the range of values of the function      |
//|               from '0' to 'a'                                    |
//|           'b' shifts the resulting value                         |
//+------------------------------------------------------------------+
__kernel void SigmoidActivation(__global TYPE* inputs,
                                __global TYPE* outputs,
                                const TYPE a, const TYPE b)
  {
   size_t i = get_global_id(0);
   outputs[i] = a / (1 + exp(-inputs[i])) - b;
  }
//+------------------------------------------------------------------+
//| Derivative of Sigmoid activation function                        |
//| Parameter 'value' current point (result of feed forward).        |
//|           'a' stretches the range of values of the function from |
//|               '0' to 'a'                                         |
//|           'b' shifts the resulting value                         |
//+------------------------------------------------------------------+
__kernel void SigmoidDerivative(__global TYPE* outputs,
                                __global TYPE* output_gr,
                                __global TYPE* input_gr,
                                const TYPE a, const TYPE b
                               )
  {
   size_t i = get_global_id(0);
   if(a == 0)
      input_gr[i] = 0;
   else
     {
      TYPE z = clamp(outputs[i] + b, (TYPE)0, a);
      input_gr[i] = z * (1 - z / a) * output_gr[i];
     }
  }
//+------------------------------------------------------------------+
//| TANH activation function                                         |
//| Parameter 'value' Weighted sum of initial data                   |
//+------------------------------------------------------------------+
__kernel void TanhActivation(__global TYPE* inputs,
                             __global TYPE* outputs)
  {
   size_t i = get_global_id(0);
   outputs[i] = tanh(inputs[i]);
  }
//+------------------------------------------------------------------+
//| Derivative of TANH activation function                           |
//| Parameter 'value' current point (result of feed forward).        |
//+------------------------------------------------------------------+
__kernel void TanhDerivative(__global TYPE* outputs,
                             __global TYPE* output_gr,
                             __global TYPE* input_gr
                            )
  {
   size_t i = get_global_id(0);
   input_gr[i] = (1 - pow(outputs[i], 2)) * output_gr[i];
  }
//+------------------------------------------------------------------+
//| LReLU activation function                                        |
//| Parameter 'value' current point (result of feed forward).        |
//|           'a' leak parameter                                     |
//+------------------------------------------------------------------+
__kernel void LReLUActivation(__global TYPE* inputs,
                              __global TYPE* outputs,
                              const TYPE a)
  {
   size_t i = get_global_id(0);
   TYPE value = inputs[i];
   outputs[i] = (value > 0 ? value : a * value);
  }
//+------------------------------------------------------------------+
//| Derivative of LReLU activation function                           |
//| Parameter 'value' current point (result of feed forward).        |
//|           'a' leak parameter                                     |
//+------------------------------------------------------------------+
__kernel void LReLUDerivative(__global TYPE* outputs,
                              __global TYPE* output_gr,
                              __global TYPE* input_gr,
                              const TYPE a)
  {
   size_t i = get_global_id(0);
   input_gr[i] = (outputs[i] > 0 ? (TYPE)1 : a) * output_gr[i];
  }
//+------------------------------------------------------------------+
//| Swish activation function                                        |
//| Parameter 'value' Weighted sum of initial data                   |
//|           'b' affects the nonlinearity of the function           |
//+------------------------------------------------------------------+
__kernel void SwishActivation(__global TYPE* inputs,
                              __global TYPE* outputs,
                              const TYPE b)
  {
   size_t i = get_global_id(0);
   TYPE value = inputs[i];
   outputs[i] = value / (1 + exp(-b * value));
  }
//+------------------------------------------------------------------+
//| Derivative of Swish activation function                          |
//| Parameter 'value' current point (result of feed forward).        |
//|           'value_input' Weighted sum of initial data             |
//|           'b' affects the nonlinearity of the function           |
//+------------------------------------------------------------------+
__kernel void SwishDerivative(__global TYPE* outputs,
                              __global TYPE* output_gr,
                              __global TYPE* input_gr,
                              const TYPE b,
                              __global TYPE* inputs)
  {
   size_t i = get_global_id(0);
   TYPE by = b * outputs[i];
   input_gr[i] = (by + (1 - by) / (1 + exp(-b * inputs[i]))) * output_gr[i];
  }
//+------------------------------------------------------------------+
//| Transfer 4 elements of TYPE vector to TYPE4                      |
//| Parameter 'array' source array of data                           |
//|           'start' first position to copy                         |
//|           'step' step between elements to copy                   |
//|           'size' Size of source array                            |
//|         'shift' Shift in source array to the 1-st copied element |
//+------------------------------------------------------------------+
TYPE4 ToVect4(__global TYPE *array, int start, int step, int size, int shift)
  {
   TYPE4 result = (TYPE4)(0, 0, 0, 0);
   step = max(1, step);
   int st = start * step + shift;
   if(st < size)
     {
      int k = (size - shift + step - 1) / step;
      switch(k)
        {
         case 0:
            break;
         case  1:
            result = (TYPE4)(array[st], 0, 0, 0);
            break;
         case  2:
            result = (TYPE4)(array[st], array[st + step], 0, 0);
            break;
         case  3:
            result = (TYPE4)(array[st], array[st + step], array[st + 2 * step], 0);
            break;
         default:
            result = (TYPE4)(array[st], array[st + step], array[st + 2 * step], array[st + 3 * step]);
            break;
        }
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TYPE Max4(TYPE4 vect, TYPE value)
  {
   TYPE result = fmax(vect.s0, value);
   result = fmax(vect.s1, result);
   result = fmax(vect.s2, result);
   return(fmax(vect.s3, result));
  }
//+------------------------------------------------------------------+
//| Transfer TYPE4 to 4 elements of TYPE vector                  |
//| Parameter 'array' target array of data                           |
//|           'value' source TYPE4 vector                          |
//|           'start' first position to copy in target array         |
//|           'step' step between elements in target array           |
//|           'size' Size of target array                            |
//|         'shift' Shift in target array to the 1-st copied element |
//+------------------------------------------------------------------+
void D4ToArray(__global TYPE *array, TYPE4 value, int start, int step, int size, int shift)
  {
   step = max(1, step);
   int st = start * step + shift;
   if(st < size)
     {
      int k = (size - shift) % step;
      k = (size - shift - k) / step - start + (k > 0 ? 1 : 0);
      switch(k)
        {
         case  3:
            array[st + 2 * step] = value.s2;
         case  2:
            array[st + step] = value.s1;
         case  1:
            array[st] = value.s0;
            break;
         default:
            array[st + 3 * step] = value.s3;
            array[st + 2 * step] = value.s2;
            array[st + step] = value.s1;
            array[st] = value.s0;
            break;
        }
     }
   return;
  }
//+------------------------------------------------------------------+
//| Kernel Feed Forward of perceptron                                |
//| Parameter 'inputs' vector of inputs data                         |
//|           'weights' matrix of weights                            |
//|           'outputs' output data                                  |
//|           'inputs_total' size of inputs vector                   |
//+------------------------------------------------------------------+
__kernel void PerceptronFeedForward(__global TYPE *inputs,
                                    __global TYPE *weights,
                                    __global TYPE *outputs,
                                    int inputs_total)
  {
   const int n = get_global_id(0);
   const int weights_total = get_global_size(0) * (inputs_total + 1);
   int shift = n * (inputs_total + 1);
   TYPE s = weights[shift + inputs_total];
   for(int i = 0; i < inputs_total; i += 4)
      s += dot(ToVect4(inputs, i, 1, inputs_total, 0), ToVect4(weights, i, 1, weights_total, shift));
   outputs[n] = s;
  }
//+------------------------------------------------------------------+
//| Kernel of calculation output gradients                           |
//| Parameter 'target' vector of target data                         |
//|           'outputs' vector of previous FF outputs data           |
//|           'gradients' vector of gradients                        |
//|           'loss_function' type of loss function                  |
//+------------------------------------------------------------------+
__kernel void CalcOutputGradient(__global TYPE *target,
                                 __global TYPE *outputs,
                                 __global TYPE *gradients,
                                 int loss_function)
  {
   const int n = get_global_id(0);
   switch(loss_function)
     {
      case 0:
         gradients[n] = target[n] - outputs[n];
         break;
      case 1:
         gradients[n] = 2 * (target[n] - outputs[n]);
         break;
      case 2:
         gradients[n] = -target[n] / (outputs[n] + 1e-37f) * log(outputs[n] + 1e-37f);
         break;
      case 3:
         gradients[n] = (target[n] - outputs[n]) / (outputs[n] * (outputs[n] - 1) + 1e-37f);
         break;
      default:
         gradients[n] = target[n] - outputs[n];
         break;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void CalcHiddenGradient(__global TYPE *gradient_inputs,
                                 __global TYPE *weights,
                                 __global TYPE *gradients,
                                 int outputs_total)
  {
   const int n = get_global_id(0);
   const int inputs_total = get_global_size(0);
   int weights_total = (inputs_total + 1) * outputs_total;
//---
   TYPE grad = 0;
   for(int o = 0; o < outputs_total; o += 4)
      grad += dot(ToVect4(gradients, o, 1, outputs_total, 0), ToVect4(weights, o, (inputs_total + 1), weights_total, n));
   gradient_inputs[n] = grad;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void CalcDeltaWeights(__global TYPE *inputs,
                               __global TYPE *delta_weights,
                               __global TYPE *gradients)
  {
   const int n = get_global_id(0);
   const int outputs_total = get_global_size(0);
   const int i = get_global_id(1);
   const int inputs_total = get_global_size(1);
//---
   TYPE grad = gradients[n];
   int shift = n * (inputs_total + 1);
   delta_weights[shift + i] = inputs[i] * grad + delta_weights[shift + i];
   if(i == 0)
      delta_weights[shift + inputs_total] += grad;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void SGDUpdate(__global TYPE *delta_weights,
                        __global TYPE *weights,
                        int total,
                        int batch_size,
                        TYPE learningRate,
                        TYPE Lambda1,
                        TYPE Lambda2
                       )
  {
   int start = 4 * get_global_id(0);
   TYPE4 delta4 = ToVect4(delta_weights, start, 1, total, 0);
   TYPE4 weights4 = ToVect4(weights, start, 1, total, 0);
   TYPE lr = learningRate / ((TYPE)batch_size);
   weights4 -= (TYPE4)(Lambda1) + Lambda2 * weights4;
   weights4 += (TYPE4)(lr) * delta4;
   D4ToArray(weights, weights4, start, 1, total, 0);
   D4ToArray(delta_weights, (TYPE4)(0), start, 1, total, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void MomentumUpdate(__global TYPE *delta_weights,
                             __global TYPE *weights,
                             __global TYPE *momentum,
                             int total, int batch_size,
                             TYPE learningRate,
                             TYPE beta,
                             TYPE Lambda1, TYPE Lambda2)
  {
   int start = 4 * get_global_id(0);
//---
   TYPE4 delta4 = ToVect4(delta_weights, start, 1, total, 0) / ((TYPE4)(batch_size));
   TYPE4 weights4 = ToVect4(weights, start, 1, total, 0);
   TYPE4 momentum4 = ToVect4(momentum, start, 1, total, 0);
   weights4 -= (TYPE4)(Lambda1) + Lambda2 * weights4;
   momentum4 = (TYPE4)(learningRate) * delta4 + (TYPE4)(beta) * momentum4;
   weights4 += momentum4;
   D4ToArray(weights, weights4, start, 1, total, 0);
   D4ToArray(momentum, momentum4, start, 1, total, 0);
   D4ToArray(delta_weights, (TYPE4)(0), start, 1, total, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void AdaGradUpdate(__global TYPE *delta_weights,
                            __global TYPE *weights,
                            __global TYPE *momentum,
                            int total, int batch_size,
                            TYPE learningRate,
                            TYPE Lambda1, TYPE Lambda2)
  {
   int start = 4 * get_global_id(0);
//---
   TYPE4 delta4 = ToVect4(delta_weights, start, 1, total, 0) / ((TYPE4)(batch_size));
   TYPE4 weights4 = ToVect4(weights, start, 1, total, 0);
   TYPE4 momentum4 = ToVect4(momentum, start, 1, total, 0);
//---
   weights4 -= (TYPE4)(Lambda1) + Lambda2 * weights4;
   momentum4 = momentum4 + pow(delta4, 2);
   weights4 += learningRate / sqrt(momentum4 + 1.0e-37f);
   D4ToArray(weights, weights4, start, 1, total, 0);
   D4ToArray(momentum, momentum4, start, 1, total, 0);
   D4ToArray(delta_weights, (TYPE4)(0), start, 1, total, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void RMSPropUpdate(__global TYPE *delta_weights,
                            __global TYPE *weights,
                            __global TYPE *momentum,
                            int total, int batch_size,
                            TYPE learningRate,
                            TYPE beta,
                            TYPE Lambda1, TYPE Lambda2)
  {
   int start = 4 * get_global_id(0);
//---
   TYPE4 delta4 = ToVect4(delta_weights, start, 1, total, 0) / ((TYPE4)(batch_size));
   TYPE4 weights4 = ToVect4(weights, start, 1, total, 0);
   TYPE4 momentum4 = ToVect4(momentum, start, 1, total, 0);
//---
   weights4 -= (TYPE4)(Lambda1) + Lambda2 * weights4;
   momentum4 = beta * momentum4 + (1 - beta) * pow(delta4, 2);
   weights4 += delta4 * learningRate / (sqrt(momentum4) + 1.0e-37f);
   D4ToArray(weights, weights4, start, 1, total, 0);
   D4ToArray(momentum, momentum4, start, 1, total, 0);
   D4ToArray(delta_weights, (TYPE4)(0), start, 1, total, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void AdaDeltaUpdate(__global TYPE *delta_weights,
                             __global TYPE *weights,
                             __global TYPE *momentumW,
                             __global TYPE *momentumG,
                             int total, int batch_size,
                             TYPE beta1, TYPE beta2,
                             TYPE Lambda1, TYPE Lambda2)
  {
   int start = 4 * get_global_id(0);
//---
   TYPE4 delta4 = ToVect4(delta_weights, start, 1, total, 0) / ((TYPE4)(batch_size));
   TYPE4 weights4 = ToVect4(weights, start, 1, total, 0);
   TYPE4 momentumW4 = ToVect4(momentumW, start, 1, total, 0);
   TYPE4 momentumG4 = ToVect4(momentumG, start, 1, total, 0);
//---
   weights4 -= (TYPE4)(Lambda1) + Lambda2 * weights4;
   momentumW4 = beta1 * momentumW4 + (1 - beta1) * pow(weights4, 2);
   momentumG4 = beta2 * momentumG4 + (1 - beta2) * pow(delta4, 2);
   weights4 += delta4 * sqrt(momentumW4) / (sqrt(momentumG4) + 1.0e-37f);
   D4ToArray(weights, weights4, start, 1, total, 0);
   D4ToArray(momentumW, momentumW4, start, 1, total, 0);
   D4ToArray(momentumG, momentumG4, start, 1, total, 0);
   D4ToArray(delta_weights, (TYPE4)(0), start, 1, total, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void AdamUpdate(__global TYPE *delta_weights,
                         __global TYPE *weights,
                         __global TYPE *momentumM,
                         __global TYPE *momentumV,
                         int total, int batch_size,
                         TYPE learningRate,
                         TYPE beta1, TYPE beta2,
                         TYPE Lambda1, TYPE Lambda2)
  {
   int start = 4 * get_global_id(0);
//---
   TYPE4 delta4 = ToVect4(delta_weights, start, 1, total, 0) / ((TYPE4)(batch_size));
   TYPE4 weights4 = ToVect4(weights, start, 1, total, 0);
   TYPE4 momentumM4 = ToVect4(momentumM, start, 1, total, 0);
   TYPE4 momentumV4 = ToVect4(momentumV, start, 1, total, 0);
//---
   momentumM4 = beta1 * momentumM4 + (1 - beta1) * delta4;
   momentumV4 = beta2 * momentumV4 + (1 - beta2) * pow(delta4, 2);
   TYPE4 m = momentumM4 / (1 - beta1);
   TYPE4 v = momentumV4 / (1 - beta2);
   weights4 -= (TYPE4)(Lambda1) + Lambda2 * weights4;
   weights4 += learningRate * m / (sqrt(v) + 1.0e-37f);
   D4ToArray(weights, weights4, start, 1, total, 0);
   D4ToArray(momentumM, momentumM4, start, 1, total, 0);
   D4ToArray(momentumV, momentumV4, start, 1, total, 0);
   D4ToArray(delta_weights, (TYPE4)(0), start, 1, total, 0);
  }
//+------------------------------------------------------------------+
//| Feed-forward kernel of the convolutional layer                   |
//| Parameters: 'inputs' input data vector                           |
//|             'weights' weight matrix                              |
//|             'outputs' vector of results                          |
//|             'inputs_total' size of input data vector             |
//|             'window' size of input data analysis window          |
//|             'step' window moving step                            |
//|             'window_out' number of filters                       |
//+------------------------------------------------------------------+
__kernel void ConvolutionFeedForward(__global TYPE *inputs,
                                     __global TYPE *weights,
                                     __global TYPE *outputs,
                                     int inputs_total,
                                     int window,
                                     int step,
                                     int window_out,
                                     int transposed_out)
  {
   const int n = get_global_id(0);
   const int neurons = get_global_size(0);
   const int weights_total = (window + 1) * window_out;
   int shift = n * step;
   for(int w = 0; w < window_out; w++)
     {
      int out = (transposed_out == 1 ? w + n * window_out : w * neurons + n);
      int shift_weights = w * (window + 1) ;
      if((shift_weights + window) >= weights_total)
         break;
      TYPE s = weights[shift_weights + window];
      for(int i = 0; i < window; i += 4)
         s += dot(ToVect4(inputs, i, 1, inputs_total, shift),
                  ToVect4(weights, i, 1, shift_weights + window, shift_weights));
      outputs[out] = s;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void ConvolutionCalcHiddenGradient(__global TYPE *gradient_inputs,
      __global TYPE *weights,
      __global TYPE *gradients,
      int window,
      int step,
      int window_out,
      int neurons,
      int transposed_out)
  {
   const int n = get_global_id(0);
   const int inputs_total = get_global_size(0);
   int weights_total = (window + 1) * window_out;
//---
   TYPE grad = 0;
   int w_start = n % step;
   int r_start = max((n - window + step) / step, 0);
   int total = (window - w_start + step - 1) / step;
   total = min((n + step) / step, total);
   for(int i = 0; i < total; i ++)
     {
      int row = r_start + i;
      if(row >= neurons)
         break;
      for(int wo = 0; wo < window_out; wo++)
        {
         int shift_g = (transposed_out == 1 ? row * window_out + wo : row + wo * neurons);
         int shift_w = w_start + (total - i - 1) * step + wo * (window + 1);
         grad += gradients[shift_g] * weights[shift_w];
        }
     }
   gradient_inputs[n] = grad;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void ConvolutionCalcDeltaWeights(__global TYPE *inputs,
      __global TYPE *delta_weights,
      __global TYPE *gradients,
      int inputs_total,
      int step,
      int neurons,
      int transposed_out)
  {
   const int inp_w = get_global_id(0);
   const int w = get_global_id(1);
   const int window = get_global_size(0) - 1;
   const int window_out = get_global_size(1);
//---
   int shift_delt = w * (window + 1) + inp_w;
   TYPE value = 0;
   if(inp_w == window)
     {
      for(int n = 0; n < neurons; n ++)
         value += gradients[transposed_out == 1 ? w + n*window_out : w * neurons + n];
     }
   else
      for(int n = 0; n < neurons; n ++)
        {
         int shift_inp = n * step + inp_w;
         if(shift_inp >= inputs_total)
            break;
         value += inputs[shift_inp] * gradients[transposed_out == 1 ? w + n*window_out : w * neurons + n];
        }
   delta_weights[shift_delt] += value;
  }
//+------------------------------------------------------------------+
//| Feed-forward kernel of the pooling layer                         |
//| Parameters: 'inputs' input data vector                           |
//|             'outputs' vector of results                          |
//|             'inputs_total' size of input data vector             |
//|             'input_neurons' vector size of 1st input data filter |
//|             'window' size of input data analysis window          |
//|             'step' window moving step                            |
//|             'activation' type of activation function             |
//+------------------------------------------------------------------+
__kernel void ProofFeedForward(__global TYPE *inputs,
                               __global TYPE *outputs,
                               int inputs_total,
                               int input_neurons,
                               int window,
                               int step,
                               int activation)
  {
   const int n = get_global_id(0);
   const int w = get_global_id(1);
   const int neurons = get_global_size(0);
   const int window_out = get_global_size(1);
   int shift = n * step;
   int out = w * neurons + n;
   int shift_inp = w * input_neurons;
   TYPE s = 0;
   TYPE k = (TYPE)1 / (TYPE)window;
   TYPE4 k4 = (TYPE4)(k);
   for(int i = 0; i < window; i += 4)
      switch(activation)
        {
         case 0:
            s += dot(ToVect4(inputs, i, 1, min(shift_inp + input_neurons, inputs_total), shift_inp + shift),
                     k4);
            break;
         case 1:
            s = Max4(ToVect4(inputs, i, 1, min(shift_inp + input_neurons, inputs_total), shift_inp + shift), s);
            break;
         default:
            break;
        }
   outputs[out] = s;
  }
//+------------------------------------------------------------------+
//| Backpropagation kernel of the pooling layer                      |
//| Parameters: 'inputs' input data vector                           |
//|             'gradient_inputs' previous layer gradients vector    |
//|             'outputs' vector of results                          |
//|             'gradients' current layer gradients vector           |
//|             'inputs_total' size of input data vector             |
//|             'outputs_total' size of outputs vector               |
//|             'window' size of input data analysis window          |
//|             'step' window moving step                            |
//|             'neurons' vector size if 1st filter of outputs       |
//|             'activation' type of activation function             |
//+------------------------------------------------------------------+
__kernel void ProofCalcHiddenGradient(__global TYPE *inputs,
                                      __global TYPE *gradient_inputs,
                                      __global TYPE *outputs,
                                      __global TYPE *gradients,
                                      int inputs_total,
                                      int outputs_total,
                                      int window,
                                      int step,
                                      int neurons,
                                      int activation)
  {
   const int n = get_global_id(0);
   const int w = get_global_id(1);
   const int input_neurons = get_global_size(0);
   const int window_out = get_global_size(1);
//---
   int start = max((n - window + step) / step, 0);
   int stop = min((n + step - 1) / step + 1, neurons);
   TYPE grad = 0;
   int shift_inp = w * input_neurons + n;
   if(shift_inp >= inputs_total)
      return;
   TYPE inp = inputs[shift_inp];
   int shift_out = w * neurons;
   for(int o = start; o < stop; o ++)
     {
      int shift_g = shift_out + o;
      if(shift_g >= outputs_total)
         break;
      switch(activation)
        {
         case 0:
            grad += gradients[shift_g] / (TYPE)window;
            break;
         case 1:
            grad += (outputs[shift_g] == inp ? gradients[shift_g] : 0);
            break;
         default:
            break;
        }
     }
   gradient_inputs[shift_inp] = grad;
  }
//+------------------------------------------------------------------+
//| LSTM block feed-forward kernel                                   |
//| Parameters: 'forgetgate' forget gate                             |
//|             'inputgate' input gate                               |
//|             'outputgate' output gate                             |
//|            'newcontent' new content                              |
//|             'memory' memory stream                               |
//|             'hiddenstate' hidden state stream                    |
//|             'outputs_total' number of elements in data stream    |
//+------------------------------------------------------------------+
__kernel void LSTMFeedForward(__global TYPE *forgetgate,
                              __global TYPE *inputgate,
                              __global TYPE *outputgate,
                              __global TYPE *newcontent,
                              __global TYPE *memory,
                              __global TYPE *hiddenstate,
                              int outputs_total)
  {
   const int n = get_global_id(0);
   const int shift = n * 4;
   TYPE4 fg = ToVect4(forgetgate, shift, 1, outputs_total, 0);
   TYPE4 ig = ToVect4(inputgate, shift, 1, outputs_total, 0);
   TYPE4 og = ToVect4(outputgate, shift, 1, outputs_total, 0);
   TYPE4 nc = ToVect4(newcontent, shift, 1, outputs_total, 0);
   TYPE4 mem = ToVect4(memory, shift, 1, outputs_total, 0);
//---
   TYPE4 temp = mem * fg;
   temp += ig * nc;
   D4ToArray(memory, temp, shift, 1, outputs_total, 0);
   temp = tanh(temp) * og;
   D4ToArray(hiddenstate, temp, shift, 1, outputs_total, 0);
  }
//+------------------------------------------------------------------+
//| LSTM block backpropagation kernel                                |
//| Parameters: 'outputs' vector of outputs                          |
//|             'gradients' current layer gradients vector           |
//|             'inputgate' input gate                               |
//|             'outputgate' output gate                             |
//|            'newcontent' new content                              |
//|             'memory' memory stream                               |
//|             'fg_gradients' forget gate gradient                  |
//|             'ig_gradients' input gate gradient                   |
//|             'og_gradients' output gate gradient                  |
//|             'nc_gradients' new content gradient                  |
//|             'outputs_total' size of outputs vector               |
//+------------------------------------------------------------------+
__kernel void LSTMCalcHiddenGradient(__global TYPE *outputs,
                                     __global TYPE *gradients,
                                     __global TYPE *inputgate,
                                     __global TYPE *outputgate,
                                     __global TYPE *newcontent,
                                     __global TYPE *memory,
                                     __global TYPE *fg_gradients,
                                     __global TYPE *ig_gradients,
                                     __global TYPE *og_gradients,
                                     __global TYPE *nc_gradients,
                                     int outputs_total)
  {
   const int n = get_global_id(0);
   int shift = n * 4;
//---
   TYPE4 out = ToVect4(outputs, shift, 1, outputs_total, 0);
   TYPE4 grad = ToVect4(gradients, shift, 1, outputs_total, 0);
   TYPE4 ig = ToVect4(inputgate, shift, 1, outputs_total, 0);
   TYPE4 og = ToVect4(outputgate, shift, 1, outputs_total, 0);
   TYPE4 nc = ToVect4(newcontent, shift, 1, outputs_total, 0);
   TYPE4 mem = ToVect4(memory, shift, 1, outputs_total, 0);
//---
   TYPE4 m = out / (og + 1.0e-37f);
//--- OutputGate gradient
   TYPE4 temp = grad * m;
   D4ToArray(og_gradients, temp, shift, 1, outputs_total, 0);
//--- Градиент памяти cкорректируем на производную TANH
   grad = grad * og * (1 - pow(m, 2));
//--- InputGate gradient
   temp = grad * nc;
   D4ToArray(ig_gradients, temp, shift, 1, outputs_total, 0);
//--- NewContent gradient
   temp = grad * ig;
   D4ToArray(nc_gradients, temp, shift, 1, outputs_total, 0);
//--- ForgetGates gradient
   temp = grad * mem;
   D4ToArray(fg_gradients, temp, shift, 1, outputs_total, 0);
  }
//+------------------------------------------------------------------+
//| Kernel calculating Self-Attention block dependency coefficients  |
//| Parameters: 'querys' tensor of queries                           |
//|             'keys' tensor of keys                                |
//|             'values' tensor of values                            |
//|             'scores' matrix of dependency coefficients           |
//|             'inputs' tensor of input data                        |
//|             'outputs' tensor of output data                      |
//|             'window' size of input data analysis window          |
//|             'key_size' size of key vector for one element        |
//+------------------------------------------------------------------+
__kernel void AttentionFeedForward(__global TYPE *querys,
                                   __global TYPE *keys,
                                   __global TYPE *scores,
                                   __global TYPE *values,
                                   __global TYPE *outputs,
                                   int window,
                                   int key_size,
                                   int mask)
  {
   const int q = get_global_id(0);
   const int units = get_global_size(0);
   const int h = get_global_id(1);
   const int heads = get_global_size(1);
   int shift_query = key_size * (q * heads + h);
   int shift_scores = units * (q * heads + h);
   TYPE summ = 0;
   for(int s = 0; s < units; s++)
     {
      TYPE score = 0;
      if(mask > 0 && s > q)
        {
         scores[shift_scores + s] = score;
         continue;
        }
      int shift_key = key_size * (s * heads + h);
      for(int k = 0; k < key_size; k ++)
         score += querys[shift_query + k] * keys[shift_key + k];
      score = exp(score / sqrt((TYPE)key_size));
      summ += score;
      scores[shift_scores + s] = score;
     }
   for(int s = 0; s < units; s++)
      scores[shift_scores + s] /= summ;
//---
   shift_query = window * (q * heads + h);
   for(int i = 0; i < window; i++)
     {
      TYPE query = 0;
      for(int v = 0; v < units; v++)
         query += values[window * (v * heads + h) + i] * scores[shift_scores + v];
      outputs[shift_query + i] = query;
     }
  }
//+------------------------------------------------------------------+
//| Kernel to propagate gradient inside the Self-Attention block     |
//| up to the level of dependency coefficient matrix Score           |
//| Parameters: 'values' tensor of values                            |
//|             'values_grad' tensor of gradients at level of values |
//|             'scores' matrix of dependency coefficients           |
//|             'scores_grad' matrix of dependency coeff. matrix     |
//|             'outputs' tensor of output data                      |
//|             'outputs_grad' tensor of gradients at output level   |
//|             'window' size of input data analysis window          |
//+------------------------------------------------------------------+
__kernel void AttentionCalcScoreGradient(__global TYPE *scores,
      __global TYPE *scores_grad,
      __global TYPE *values,
      __global TYPE *values_grad,
      __global TYPE *outputs_grad,
      __global TYPE *scores_temp,
      int window)
  {
   const int q = get_global_id(0);
   const int units = get_global_size(0);
   const int h = get_global_id(1);
   const int heads = get_global_size(1);
   int shift_value = window * (q * heads + h);
   int shift_score = units * (q * heads + h);
//--- Gradient propagation to Values
   for(int i = 0; i < window; i ++)
     {
      TYPE grad = 0;
      for(int g = 0; g < units; g++)
         grad += scores[units * (g * heads + h) + q] * outputs_grad[window * (g * heads + h) + i];
      values_grad[shift_value + i] = grad;
     }
//--- Gradient propagation to Score
   for(int k = 0; k < units; k++)
     {
      TYPE grad = 0;
      for(int i = 0; i < window; i++)
         grad += outputs_grad[shift_value + i] * values[window * (k * heads + h) + i];
      scores_temp[shift_score + k] = grad;
     }
//--- Adjust by Softmax derivative
   for(int k = 0; k < units; k++)
     {
      TYPE grad = 0;
      TYPE score = scores[shift_score + k];
      for(int i = 0; i < units; i++)
         grad += scores[shift_score + i] * ((int)(i == k) - score) * scores_temp[shift_score + i];
      scores_grad[shift_score + k] = grad;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void AttentionCalcHiddenGradient(__global TYPE *querys,
      __global TYPE *querys_grad,
      __global TYPE *keys,
      __global TYPE *keys_grad,
      __global TYPE *scores_grad,
      int key_size)
  {
   const int q = get_global_id(0);
   const int units = get_global_size(0);
   const int h = get_global_id(1);
   const int heads = get_global_size(1);
   int shift_query = key_size * (q * heads + h);
   int shift_score = units * (q * heads + h);
//--- Gradient prpagation to Querys and Keys
   const TYPE k = 1 / sqrt((TYPE)key_size);
//---
   for(int i = 0; i < key_size; i++)
     {
      TYPE grad_q = 0;
      TYPE grad_k = 0;
      for(int s = 0; s < units; s++)
        {
         grad_q += keys[key_size * (s * heads + h) + i] * scores_grad[shift_score + s];
         grad_k += querys[key_size * (s * heads + h) + i] * scores_grad[units * (s * heads + h) + q];
        }
      querys_grad[shift_query + i] = grad_q * k;
      keys_grad[shift_query + i] = grad_k * k;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void GPTFeedForward(__global TYPE *querys,
                             __global TYPE *keys,
                             __global TYPE *scores,
                             __global TYPE *values,
                             __global TYPE *outputs,
                             int key_size,
                             int units,
                             int current)
  {
   const int h = get_global_id(0);
   const int heads = get_global_size(0);
   int shift_query = key_size * h;
   int shift_scores = units * h;
   TYPE summ = 0;
   for(int s = 0; s < units; s++)
     {
      TYPE score = 0;
      int shift_key = key_size * (s * heads + h);
      for(int k = 0; k < key_size; k ++)
        {
         if(s == current)
            keys[shift_key + k] = querys[shift_query + k + heads * key_size];
         score += querys[shift_query + k] * keys[shift_key + k];
        }
      score = exp(score / sqrt((TYPE)key_size));
      summ += score;
      scores[shift_scores + s] = score;
     }
   for(int s = 0; s < units; s++)
      scores[shift_scores + s] /= summ;
//---
   shift_query = key_size * h;
   for(int i = 0; i < key_size; i++)
     {
      TYPE query = 0;
      for(int v = 0; v < units; v++)
        {
         if(v == current)
            values[key_size * (v * heads + h) + i] = querys[(2 * heads + h) * key_size + i];
         query += values[key_size * (v * heads + h) + i] * scores[shift_scores + v];
        }
      outputs[shift_query + i] = query;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void GPTCalcScoreGradient(__global TYPE *scores,
                                   __global TYPE *scores_grad,
                                   __global TYPE *values,
                                   __global TYPE *values_grad,
                                   __global TYPE *outputs_grad,
                                   __global TYPE *scores_temp,
                                   int window,
                                   int units,
                                   int current)
  {
   const int h = get_global_id(0);
   const int heads = get_global_size(0);
   int shift_value = window * (2 * heads + h);
   int shift_score = units * h;
//--- Gradient propagation to Values
   for(int i = 0; i < window; i ++)
      values_grad[shift_value + i] = scores[units * h + current] * outputs_grad[window * h + i];
//--- Gradient propagation to Score
   for(int k = 0; k < units; k++)
     {
      TYPE grad = 0;
      for(int i = 0; i < window; i++)
         grad += outputs_grad[shift_value + i] * values[window * (k * heads + h) + i];
      scores_temp[shift_score + k] = grad;
     }
//--- Adjust by Softmax derivative
   for(int k = 0; k < units; k++)
     {
      TYPE grad = 0;
      TYPE score = scores[shift_score + k];
      for(int i = 0; i < units; i++)
         grad += scores[shift_score + i] * ((int)(i == k) - score) * scores_temp[shift_score + i];
      scores_grad[shift_score + k] = grad;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void GPTCalcHiddenGradient(__global TYPE *querys,
                                    __global TYPE *querys_grad,
                                    __global TYPE *keys,
                                    __global TYPE *scores_grad,
                                    int key_size,
                                    int units,
                                    int current)
  {
   const int h = get_global_id(0);
   const int heads = get_global_size(0);
   int shift_query = key_size * h;
   int shift_key = key_size * (heads + h);
   int shift_score = units * h;
//--- Gradient prpagation to Querys and Keys
   const TYPE k = 1 / sqrt((TYPE)key_size);
//---
   for(int i = 0; i < key_size; i++)
     {
      TYPE grad_q = 0;
      TYPE grad_k = 0;
      for(int s = 0; s < units; s++)
        {
         grad_q += keys[key_size * (s * heads + h) + i] * scores_grad[shift_score + s];
         if(s == current)
            grad_k += querys[key_size * h + i] * scores_grad[units * h + current];
        }
      querys_grad[shift_query + i] = grad_q * k;
      querys_grad[shift_key + i] = grad_k * k;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void BatchNormFeedForward(__global TYPE *inputs,
                                   __global TYPE *options,
                                   __global TYPE *weights,
                                   __global TYPE *output,
                                   int batch,
                                   int total)
  {
   int n = get_global_id(0);
   if(batch <= 1)
     {
      D4ToArray(output, ToVect4(inputs, n * 4, 1, total, 0), n * 4, 1, total, 0);
      return;
     }
   int shift = n * 4;
   int shift_options = n * 3 * 4;
   int shift_weights = n * 2 * 4;
//---
   TYPE4 inp = ToVect4(inputs, shift, 1, total, 0);
   TYPE4 mean = ToVect4(options, shift, 3, total * 3, 0) * ((TYPE)batch - 1) + inp ;
   if(options[shift_options ] > 0 && options[shift_options + 1] > 0)
      mean /= (TYPE4)batch;
   TYPE4 delt = inp - mean;
   TYPE4 variance = ToVect4(options, shift, 3, total * 3, 1) * ((TYPE)batch - 1) + pow(delt, 2);
   if(options[shift_options + 1] > 0)
      variance /= (TYPE4)batch;
   TYPE4 nx = delt / sqrt(variance + 1e-37f);
//---
   if(weights[shift_weights] == 0)
      D4ToArray(weights, (TYPE4)1, shift, 2, total * 2, 0);
//---
   TYPE4 res = ToVect4(weights, shift, 2, total * 2, 0) * nx + ToVect4(weights, shift, 2, total * 2, 1);
//---
   D4ToArray(options, mean, shift, 3, total * 3, 0);
   D4ToArray(options, variance, shift, 3, total * 3, 1);
   D4ToArray(options, nx, shift, 3, total * 3, 2);
   D4ToArray(output, res, shift, 1, total, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void BatchNormCalcHiddenGradient(__global TYPE *options,
      __global TYPE *gradient,
      __global TYPE *inputs,
      __global TYPE *gradient_inputs,
      __global TYPE *weights,
      int batch,
      int total
                                         )
  {
   int n = get_global_id(0);
   int shift = n * 4;
   if(batch <= 1)
     {
      D4ToArray(gradient_inputs, ToVect4(gradient, shift, 1, total, 0), shift, 1, total, 0);
      return;
     }
//---
   TYPE4 inp = ToVect4(inputs, shift, 1, total, 0);
   TYPE4 gnx = ToVect4(gradient, shift, 1, total, 0) * ToVect4(weights, shift, 2, total * 2, 0);
   TYPE4 temp = 1 / sqrt(ToVect4(options, shift, 3, total * 3, 1) + 1e-37f);
   TYPE4 delt = inp - ToVect4(options, shift, 3, total * 3, 0);
   TYPE4 gvar = delt / (-2 * pow(ToVect4(options, shift, 3, total * 3, 1) + 1.0e-37f, 3.0f / 2.0f)) * gnx;
   TYPE4 gmu = (-temp) * gnx - gvar * 2 * delt / (TYPE4)batch;
   TYPE4 gx = temp * gnx + gmu / (TYPE4)batch + gvar * 2 * delt / (TYPE4)batch;
//---
   D4ToArray(gradient_inputs, gx, shift, 1, total, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void BatchNormCalcDeltaWeights(__global TYPE *options,
                                        __global TYPE *delta_weights,
                                        __global TYPE *gradients)
  {
   const int n = get_global_id(0);
   int shift_options = n * 3;
   int shift_weights = n * 2;
//---
   TYPE grad = gradients[n];
   delta_weights[shift_weights] += grad * options[shift_options + 2];
   delta_weights[shift_weights + 1] += grad;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void MaskMult(__global TYPE *inputs,
                       __global TYPE *mask,
                       __global TYPE *outputs,
                       int outputs_total)
  {
   const int n = get_global_id(0) * 4;
//---
   TYPE4 out = ToVect4(inputs, n, 1, outputs_total, 0) * ToVect4(mask, n, 1, outputs_total, 0);
   D4ToArray(outputs, out, n, 1, outputs_total, 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void Sum(__global TYPE *inputs1,
                  __global TYPE *inputs2,
                  __global TYPE *outputs)
  {
   const int n = get_global_id(0);
//---
   outputs[n] = inputs1[n] + inputs2[n];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void LayerNormalize(__global TYPE* inputs,
                             __global TYPE* outputs,
                             __global TYPE* stds,
                             const int total,
                             const int std_shift)
  {
   uint i = (uint)get_global_id(0);
   uint l = (uint)get_local_id(0);
   uint ls = min((uint)get_local_size(0), (uint)LOCAL_SIZE);
   __local TYPE temp[LOCAL_SIZE];
//---
   uint count = 0;
   do
     {
      uint shift = count * ls + l;
      temp[l] = (count > 0 ? temp[l] : 0) + (shift < total ? inputs[shift] : 0);
      count++;
     }
   while((count * ls + l) < total);
   temp[l] /= (TYPE)total;
   barrier(CLK_LOCAL_MEM_FENCE);
   count = ls;
   do
     {
      count = (count + 1) / 2;
      temp[l] += (l < count ? temp[l + count] : 0);
      barrier(CLK_LOCAL_MEM_FENCE);
     }
   while(count > 1);
//---
   TYPE mean = (TYPE) temp[0];
//---
   count = 0;
   do
     {
      uint shift = count * ls + l;
      temp[l] = (count > 0 ? temp[l] : 0) + (shift < total ? (TYPE)pow(inputs[shift] - mean, 2) : 0);
      count++;
     }
   while((count * ls + l) < total);
   temp[l] /= (TYPE)total;
   barrier(CLK_LOCAL_MEM_FENCE);
   count = ls;
   do
     {
      count = (count + 1) / 2;
      temp[l] += (l < count ? temp[l + count] : 0);
      barrier(CLK_LOCAL_MEM_FENCE);
     }
   while(count > 1);
//---
   TYPE std = (TYPE)sqrt(temp[0]);
   if(l == 0)
      stds[std_shift] = std;
   count = 0;
   while((count * ls + l) < total)
     {
      uint shift = count * ls + l;
      outputs[shift] = (inputs[shift] - mean) / (std + 1e-37f);
      count++;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void LayerNormalizeGradient(__global TYPE* outputs,
                                     __global TYPE* out_gradient,
                                     __global TYPE* inp_gradient,
                                     __global TYPE* stds,
                                     const int total,
                                     const int std_shift)
  {
   uint i = (uint)get_global_id(0);
   uint l = (uint)get_local_id(0);
//---
   uint ls = min((uint)get_local_size(0), (uint)LOCAL_SIZE);
   __local TYPE dSTD[LOCAL_SIZE];
   __local TYPE dMean1[LOCAL_SIZE];
   __local TYPE dMean2[LOCAL_SIZE];
   uint count = 0;
   do
     {
      uint shift = count * ls + l;
      dSTD[l] = (count > 0 ? dSTD[l] : 0) - (shift < total ? out_gradient[shift] * outputs[shift] / (2 * (pow(stds[std_shift], (TYPE)2) + 1e-37f)) : 0);
      dMean1[l] = (count > 0 ? dMean1[l] : 0) - (shift < total ? out_gradient[shift] / (stds[std_shift] + 1e-37f) : 0);
      dMean2[l] = (count > 0 ? dMean2[l] : 0) - (shift < total ? 2 * outputs[shift] * stds[std_shift] / (TYPE)total : 0);
      count++;
     }
   while((count * ls + l) < total);
   barrier(CLK_LOCAL_MEM_FENCE);
   count = ls;
   do
     {
      count = (count + 1) / 2;
      dSTD[l] += (l < count ? dSTD[l + count] : 0);
      dMean1[l] += (l < count ? dMean1[l + count] : 0);
      dMean2[l] += (l < count ? dMean2[l + count] : 0);
      barrier(CLK_LOCAL_MEM_FENCE);
     }
   while(count > 1);
//---
   TYPE dstd = dSTD[0];
   TYPE dmean = dMean1[0] + dstd * dMean2[0];
//---
   count = 0;
   while((count * ls + l) < total)
     {
      uint shift = count * ls + l;
      inp_gradient[shift] = out_gradient[shift] / (stds[std_shift] + 1e-32f) + (2 * dstd * outputs[shift] * stds[std_shift]  + dmean) / total;
      count++;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void SoftMaxActivation(__global TYPE* inputs,
                                __global TYPE* outputs,
                                const ulong total)
  {
   uint i = (uint)get_global_id(0);
   uint l = (uint)get_local_id(0);
   uint h = (uint)get_global_id(1);
   uint ls = min((uint)get_local_size(0), (uint)LOCAL_SIZE);
//---
   __local TYPE temp[LOCAL_SIZE];
   uint count = 0;
   for(count = l; (count < total && l < ls); count += ls)
     {
      uint shift = h * total + count;
      temp[l] = (count > l ? temp[l] : 0) + exp(inputs[shift]);
     }
   barrier(CLK_LOCAL_MEM_FENCE);
   count = ls;
   do
     {
      count = (count + 1) / 2;
      temp[l] += (l < count && (l + count) < ls ? temp[l + count] : 0);
      barrier(CLK_LOCAL_MEM_FENCE);
     }
   while(count > 1);
//---
   TYPE sum = temp[0];
   for(count = l; count < total; count += ls)
     {
      uint shift = h * total + count;
      outputs[shift] = exp(inputs[shift]) / (sum + 1e-37f);
     }
  }
//+------------------------------------------------------------------+
//| Derivative of SoftMax activation function                        |
//| Parameter 'outputs' vector of previous FF outputs data           |
//|           'gradients' vector of gradients                        |
//|           'outputs_total' size of outputs vector                 |
//+------------------------------------------------------------------+
__kernel void SoftMaxDerivative(__global TYPE* outputs,
                                __global TYPE* output_gr,
                                __global TYPE* input_gr)
  {
   size_t i = get_global_id(0);
   size_t outputs_total = get_global_size(0);
   size_t shift = get_global_id(1) * outputs_total;
   TYPE output = outputs[shift + i];
   TYPE result = 0;
   for(int j = 0; j < outputs_total; j++)
      result += output * (i == j ? 1 - output : -outputs[shift + j]) * output_gr[shift + j];
   input_gr[shift + i] = result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void Split(__global TYPE* source,
                    __global TYPE* target1,
                    __global TYPE* target2,
                    const int total_source,
                    const int total_target1,
                    const int total_target2
                   )
  {
   int n = get_global_id(0);
   int total = get_global_size(0);
   for(int i = n; i < total_source; i += total)
     {
      if(i < total_target1)
         target1[i] = source[i];
      else
        {
         int t2 = i - total_target1;
         if(t2 < total_target2)
            target2[t2] = source[i];
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
__kernel void Concatenate(__global TYPE* source1,
                          __global TYPE* source2,
                          __global TYPE* target,
                          const int total_source1,
                          const int total_source2,
                          const int total_target
                         )
  {
   int n = get_global_id(0);
   int total = get_global_size(0);
   for(int i = n; i < total_target; i += total)
     {
      if(i < total_source1)
         target[i] = source1[i];
      else
        {
         int t2 = i - total_source1;
         if(t2 < total_source2)
            target[i] = source2[t2];
        }
     }
  }
//+------------------------------------------------------------------+
