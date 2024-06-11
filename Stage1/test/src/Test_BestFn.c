#include "Test_BestFn.h"

int Test_BestFn()
{
    int param = 9;
    int res = 0;
    res += BestFn(param);

    int check = param + 10;
//    printf("calling BestFn through Test_BestFn with param: %d, res %d, check %d\n", param, res, check);
    assert( res == check );

    if( res != check ) { return 1; }

    // return 1; // if switched -> compilation will halt and exit.
    return 0;
}

#ifdef UNIT_TEST
int main()
{
    int failed = Test_BestFn();

    // Realistically the assert should throw an error and this should not be reached.
    if ( failed > 0 )
    {
        return 2;
    }
    return 0;
}
#endif