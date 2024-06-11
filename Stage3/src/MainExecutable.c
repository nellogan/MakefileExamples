#include <stdio.h>
#include "BestFn.h"
#include "Work.h"
#include "Support.h"
#include "GPUHadamardProductReduction.h"
#include "CUDANoUnitTest.h"

#include <stdlib.h>

#ifdef CUDA_CAPABLE
int GPU_Actions(int n1, int n2)
{
    int res = 0;
    res += (int)GPUHadamardProductReduction(n1);
    res += CUDANoUnitTest(n2);
    return res;
}
#else
int GPU_Actions(int n1, int n2)
{
    return 0;
}
#endif


int main()
{
    int params = 10;
    int count = 10;
    int support_number = 10;
    int n1 = 1024;
    int n2 = 99;

    int res = 0;

    res += BestFn(params); // 20
    res += Work(count); // 20 + 31
    res += Support(support_number); // 20 + 31 + 22
    // GPUHadamardProductReduction(n) returns n1 * 12.0f
//    res += (int)GPUHadamardProductReduction(n1); // 20 + 31 + 22 + 12288
//    // CUDANoUnitTest(n2) returns n2
//    res += CUDANoUnitTest(n2); // 20 + 31 + 22 + 12288 + 99

    res += GPU_Actions(n1, n2);
    // CUDA_CAPABLE -> 20 + 31 + 22 + 12288 + 99 = 12460
    // else         -> 20 + 31 + 22 = 73
    printf("final sum %d\n", res);
    return 0;
}