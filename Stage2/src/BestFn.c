#include "BestFn.h"

//#include <stdlib.h>
int BestFn(int param)
{
    /*
    NOTE: If -O3 (current default = -O0) is enabled in OPTIMIZATION_FLAGS (Stage3/makefile) then memory leak/error will
    not occur as it is optimized out. While if -O0, -O1, and -O2 is used instead, it will.
    Uncommenting the two lines below (as well as #include <stdlib.h>)and re-running Stage3/test/makefile will trigger
    valgrinds return status to not be 0 (from --error-exitcode=2). Thus halting compilation and exiting.
    */
//    int *arr = malloc(32*sizeof(int));
//    arr[0] = 111;

    int plus = 10;
    int sum = param + plus;
//    printf("BestFn called with param: %d, sum %d\n", param, sum);
    return sum;
}