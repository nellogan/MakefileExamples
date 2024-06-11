#include "BestFn.h"

int Work(int count)
{
    int plus = 11;
    int sum = BestFn(count) + plus;
    printf("Work called with count: %d, sum %d\n", count, sum);
    return sum;
}