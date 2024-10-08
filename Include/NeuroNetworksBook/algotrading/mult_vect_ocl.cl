//--- By default, support for double type is disabled in most GPUs
//--- cl_khr_fp64 directive enables support for double type
//--- it can be used if double type is supported by hardware
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
//+------------------------------------------------------------------+
//| OpenCL kernel for product of a matrix by a vector                |
//+------------------------------------------------------------------+
TYPE4 ToVect(__global TYPE *array, int start, int size, int shift)
  {
   TYPE4 result = (TYPE4)0;
   if(start < size)
     {
      switch(size - start)
        {
         case  1:
            result = (TYPE4)(array[shift+start], 0, 0, 0);
            break;
         case  2:
            result = (TYPE4)(array[shift+start], array[shift+start + 1], 0, 0);
            break;
         case  3:
            result = (TYPE4)(array[shift+start], array[shift+start + 1], array[shift+start + 2], 0);
            break;
         default:
            result = (TYPE4)(array[shift+start], array[shift+start + 1], array[shift+start + 2], array[shift+start + 3]);
            break;
        }
     }
   return result;
  }
//---
__kernel void MultVectors(__global TYPE *source1,
                          __global TYPE *source2,
                          __global TYPE *result,
                          int cols)
  {
   int shift = get_global_id(0) * cols;
   TYPE z = 0;
   for(int i = 0; i < cols; i+=4)
     {
      TYPE4 x = ToVect(source1, i, cols, shift);
      TYPE4 y = ToVect(source2, i, cols, 0);
      z += dot(x,y);
     }
   result[get_global_id(0)] = z;
  }
//+------------------------------------------------------------------+
