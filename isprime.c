#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <flint/fmpz_mod.h>
#include "smallprime.h"

typedef struct
{
    // 不为 0 则使用小素因子试除，1 用小于30的因子，2用小于2048的因子
    uint8_t small_divisor_test : 2;
    // 不为 0 使用米勒-罗宾算法测试，值为测试次数，用 2 开始连续素数为基
    uint8_t miller_rabin_test : 1;
    uint8_t lucas_test : 1;                     // 卢卡斯算法测试
    uint8_t quadratic_field_frobenius_test : 1; // 二次域Frobenius算法测试
    uint32_t undefine : 27;
} primality_test_method;

const primality_test_method max_method = {1, 1, 1, 1, 1, 0};
const primality_test_method min_method = {0, 0, 1, 1, 1, 0};

// 返回 0 是合数， 1 是素数，2 是未定义
int small_divisor_test(const fmpz_t p, const int m)
{
    // 负数，0， 1 都不是素数
    if (fmpz_cmp_si(p, 1) <= 0)
        return 0;

    // 偶数，除了 2 是素数，都不是素数
    if (fmpz_is_even(p))
        return (fmpz_equal_ui(p, 2) == 1 ? 1 : 0);

    uint64_t max_d;
    switch (m)
    {
    case 1:
        max_d = 30;
        break;
    case 2:
    case 3:
        max_d = 2048;
    }

    int max_i = sizeof(smallprime) / sizeof(uint64_t), i;
    for (i = 1; (i < max_i) && (smallprime[i] * smallprime[i] <= p); i++)
        if (fmpz_tdiv_ui(p, smallprime[i]) == 0)
            return (fmpz_equal_ui(p, smallprime[i]) == 1 ? 1 : 0);
    if (i == max_i)
        return (fmpz_cmp_ui(p, 2048 * 2048) <= 0 ? 1 : 2);
}

// method 传递测试方法
bool primality_test(const fmpz_t p, primality_test_method method)
{
    int result;
    if (method.small_divisor_test > 0)
    {
        result = small_divisor_test(p, method.small_divisor_test);
        if (result < 2)
            return (result == 1);
    }
    if (method.miller_rabin_test > 0)
    {
        fmpz_is_strong_probabprime(p, 2);
    }
}

int main()
{
    return 0;
}