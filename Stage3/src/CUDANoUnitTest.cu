#include "CUDANoUnitTest.h"

__global__ void CUDANoUnitTestKernel()
{
    int global_thread_id = threadIdx.x + blockIdx.x * blockDim.x;
    printf("GPU Kernel in CUDANoUnitTest.cu says: Hello! from global_thread_id %d\n", global_thread_id);
}

int CUDANoUnitTest(int n)
{
    CUDANoUnitTestKernel<<<2, 2>>>();
    cudaDeviceSynchronize();
    return n;
}