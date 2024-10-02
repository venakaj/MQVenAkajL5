//+------------------------------------------------------------------+
//| Activation function enum                                         |
//+------------------------------------------------------------------+
enum Activation_Function
{
  AFHardSigmoid = AF_HARD_SIGMOID,
  AFSigmoid = AF_SIGMOID,
  AFSwish = AF_SWISH,
  AFSoftSign = AF_SOFTSIGN,
  AFTangent = AF_TANH,
};

//+------------------------------------------------------------------+
//| Loss function enum                                               |
//+------------------------------------------------------------------+
enum Loss
{
  BinaryCrossEntropy = LOSS_BCE,
  CategoricalCrossEntropy = LOSS_CCE,
  MeanSquaredError = LOSS_MSE,
  Hinge = LOSS_HINGE,
  CategoricalHing = LOSS_CAT_HINGE,
};

struct NormalizationStructure
{
  vector min;
  vector max;
  NormalizationStructure::NormalizationStructure(ulong columns)
  {
    min.Resize(columns);
    max.Resize(columns);
  }
};

// Display array
void displayArray(double &array[], string name)
{

  for (int i = 0; i < ArraySize(array); i++)
  {
    Print(name, "[", i, "]:", array[i]);
  }
}

//+------------------------------------------------------------------+
//| NewBar function                                                  |
//+------------------------------------------------------------------+
bool NewBar(string Symbol, ENUM_TIMEFRAMES Period, int &_OldNumBars)
{
  int CurrentNumBars = Bars(Symbol, Period);
  if (_OldNumBars != CurrentNumBars)
  {
    _OldNumBars = CurrentNumBars;
    return true;
  }
  return false;
}

//+------------------------------------------------------------------+
//| Vector To Matrix function                                        |
//+------------------------------------------------------------------+
matrix VectorToMatrix(const vector &v, ulong cols = 1)
{
  ulong rows = 0;
  matrix mat = {};
  if (v.Size() % cols > 0)
  {
    printf(__FUNCTION__, "Invalid num Of cols for new matrix");
    return mat;
  }
  rows = v.Size() / cols;

  mat.Resize(rows, cols);

  for (ulong i = 0, index = 0; i < rows; i++)
    for (ulong j = 0; j < cols; j++, index++)
      mat[i][j] = v[index];

  return mat;
}

//+------------------------------------------------------------------+
//| Matrix To Vector function                                        |
//+------------------------------------------------------------------+
vector MatrixToVector(const matrix &Mat)
{
  vector v = {};
  if (v.Assign(Mat))
    printf(__FUNCTION__, "Failed converting a matrix to a vector");
  return v;
}

//+------------------------------------------------------------------+
//| BPMinMaxNormalization function                                   |
//+------------------------------------------------------------------+
void BPMinMaxNormalization(vector &v, ulong _inputNumcol, NormalizationStructure &_minMaxNorm)
{
  if (v.Size() != _inputNumcol)
  {
    printf("Cant Normalize the data, Vector size must be = the size of thz matrix columns");
    return;
  }
  for (ulong i = 0; i < _inputNumcol; i++)
    v[i] = (v[i] - _minMaxNorm.min[i]) / (_minMaxNorm.max[i] - _minMaxNorm.min[i]);
}



