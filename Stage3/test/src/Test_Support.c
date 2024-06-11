#include "Test_Support.h"

int Test_Support()
{
    int support_number = 9;
    int res = 0;
    res += Support(support_number);

    int check = support_number + 12;
//    printf("calling Support through Test_Support with support_number: %d, res %d, check %d\n",
//           support_number, res, check);
    assert( res == check );

    if( res != check ) { return 1; }

    // return 1; // if switched -> compilation will halt and exit.
    return 0;
}

#ifdef UNIT_TEST
int main()
{
    int failed = Test_Support();

    // Realistically the assert should throw an error and this should not be reached.
    if ( failed > 0 )
    {
        return 2;
    }
    return 0;
}
#endif