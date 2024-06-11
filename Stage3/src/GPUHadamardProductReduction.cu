#include "GPUHadamardProductReduction.h"

__global__ void GPUHadamardProduct(float* arr1, float* arr2)
{
    int global_thread_id    = threadIdx.x + blockIdx.x * blockDim.x;
    arr1[global_thread_id] *= arr2[global_thread_id];
}


float GPUHadamardProductReduction(int n)
{
    float* arr1;
    float* arr2;

    int block_size = 256;
    int num_blocks = (n + block_size - 1) / block_size;
    /*
    If padded_size is set to n: will trigger compute-sanitize to throw an error exit code
    (assuming (n % block_size != 0) from Test_GPUHadamardProductReduction).
    */
//     int padded_size =  n;
    int padded_size =  num_blocks*block_size;

    cudaMallocManaged(&arr1, padded_size*sizeof(float));
    cudaMallocManaged(&arr2, padded_size*sizeof(float));

    for ( int i=0; i<n; i++ )
    {
        arr1[i] = 3.0f;
        arr2[i] = 4.0f;
    }

    for ( int i=n; i<padded_size; i++ )
    {
        arr1[i] = 0.0f;
        arr2[i] = 0.0f;
    }

    GPUHadamardProduct<<<num_blocks, block_size>>>(arr1, arr2);
    cudaDeviceSynchronize();

    float sum = 0.0f;
    for ( int i=0; i<n; i++ )
    {
        sum += arr1[i];
    }

    cudaFree(arr1);
    cudaFree(arr2);

    return sum;
}