#include <stdio.h>
#include "BestFn.h"
#include "Work.h"
#include "Support.h"

#include <stdlib.h>

int main()
{
    int params = 10;
    int count = 10;
    int support_number = 10;
    int res = 0;

    res += BestFn(params);
//    printf("\n");
    res += Work(count);
//    printf("\n");
    res += Support(support_number);


    printf("end main, final sum %d\n", res);
    return 0;
}