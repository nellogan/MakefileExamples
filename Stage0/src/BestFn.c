#include "BestFn.h"

int BestFn(int param)
{
    int plus = 10;
    int sum = param + plus;
    printf("BestFn called with param: %d, sum %d\n", param, sum);
    return sum;
}