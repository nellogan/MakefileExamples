#include "Test_Work.h"

int Test_Work()
{
    int count = 9;
    int res = 0;
    res += Work(count);

    int check = count + 10 + 11;
//    printf("calling Work through Test_Work with count: %d, res %d, check %d\n", count, res, check);
    assert( res == check );

    if( res != check ) { return 1; }

    // return 1; // if switched -> compilation will halt and exit.
    return 0;
}

#ifdef UNIT_TEST
int main()
{
    int failed = Test_Work();

    // Realistically the assert should throw an error and this should not be reached.
    if ( failed > 0 )
    {
        return 2;
    }
    return 0;
}
#endif