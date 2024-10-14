//Matrix multiplication kernel with non-square matrix
__global__ void gpu_mult(double *a, double *b, double *c, int M, int N, int K)
{
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int col = blockIdx.x * blockDim.x + threadIdx.x;

  if(row < M && col < K)
  {
    int temp = 0;
    for(int i = 0; i < N; i++)
    {
        temp += a[row * N + i] * b[i * K + col];
    }
    c[row * K + col] = temp;
  }
}