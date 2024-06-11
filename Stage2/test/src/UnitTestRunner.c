#include "Test_BestFn.h"
#include "Test_Work.h"
#include "Test_Support.h"

//#include <stdlib.h>
int main(void)
{
    /*
    NOTE: If -O3 (current default = -O0) is enabled in OPTIMIZATION_FLAGS (Stage3/makefile) then memory leak/error will
    not occur as it is optimized out. While if -O0, -O1, and -O2 is used instead, it will.
    Uncommenting the two lines below (as well as #include <stdlib.h>)and re-running Stage3/test/makefile will trigger
    valgrinds return status to not be 0 (from --error-exitcode=2). Thus halting compilation and exiting.
    */
//    int *arr = malloc(32*sizeof(int));
//    arr[0] = 111;

    int fails = 0;
    fails += Test_BestFn();
    fails += Test_Work();
    fails += Test_Support();

    if ( fails == 0 )
    {
        printf("All UnitTests passed.\n");
    }
    else // Realistically the asserts in each unit test will throw an error; therefore, this case should not occur.
    {
        printf("UnitTestRunner has encountered %d failures.\n", fails);
    }
    return 0;
}