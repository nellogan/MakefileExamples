#include "GPUHadamardProductReduction.h"

int Test_GPUHadamardProductReduction()
{
    int n = 1021;
    float sum = GPUHadamardProductReduction(n);
    float check = n * 12.0f;

    assert( sum == check );

    if ( sum != check ) { return 1; }

    // return 1; // if switched -> compilation will halt and exit.
    return 0;
}

#ifdef UNIT_TEST
int main()
{
    int failed = Test_GPUHadamardProductReduction();

    if ( failed > 0 )
    {
        return 2;
    }
    return 0;
}
#endif