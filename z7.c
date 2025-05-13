#include <stdio.h>
#include <stdlib.h>

#define  M 15

void test(int a, int b, int c)
{
    int mask[M+1];
    mask[0] = 0;
    for (int i = 1; i <= 7; i++)
        mask[i] = 1;

    mask[abs(a)] = 0;
    mask[abs(b)] = 0;
    mask[abs(c)] = 0;
    mask[abs(a + b)] = 0;
    mask[abs(a + c)] = 0;
    mask[abs(c + b)] = 0;
    mask[abs(a + b + c)] = 0;
    for (int i = 1; i <= 7; i++)
        if (mask[i] == 1)
            return;
    printf("%d %d %d\n", a, b, c);
}

int main(void)
{
    int a, b, c;
    for (a = -15; a <= 15; a++)
        for (b = a + 1; b <= 7; b++)
            for (c = b + 1; c <= 7; c++)
                if (abs(a + b) <= 7 && abs(b + c) <= 7 && abs(a + c) <= 7)
                    if (abs(a + b + c) <= 7)
                        test(a, b, c);

    return 0;
}