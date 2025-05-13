
using Hecke

function qfconjmod(x, n)
    re = coeff(x, 0)
    ir = mod(ZZ(-coeff(x, 1)), n)
    return parent(x)([re, ir])
end

function qfpowermod(x, p , n)
    @assert p >= 0
    p == 0 && return one(x)
    b = x
    t = ZZ(prevpow(BigInt(2), BigInt(p)))
    r = one(x)
    while true
        if p >= t
            r = mod(r * b, n)
            p -= t
        end
        t >>= 1
        t <= 0 && break
        r = mod(r * r ,n)
    end
    return r
end

function frobenius(n)
    small = [
               -1, 2, 3,   5,  7, 11, 13, 17, 19, 23,
              29,  31, 37,  41, 43, 47, 53, 59,
              61,  67, 71, 73, 79, 83, 89, 97,
              101,103,107,109,113,127
            ]
    find = false
    global p = 0
    for c in small
        if jacobi_symbol(ZZ(c), ZZ(n)) == -1
            find = true
            global p = c
            break
        end
    end
    if !find
        #n is prefect square number?
        sq = isqrt(n)
        if sq * sq == n
                return false
        end
        c = next_prime(last(small)+1)
        while jacobi_symbol(ZZ(c), ZZ(n)) != -1
            c = next_prime(c+1)
        end
        global p = c
    end
    #println("$n: $p")
    F, d = quadratic_field(p)
    if p >= 3
        b = F([1, 1])
    else
        b = F([2, 1])
    end
    r = qfpowermod(b, n, n)
    nb = qfconjmod(b, n)
    return r == nb
end

global b = big(10)^67
@time for i in range(3, step = 2, stop = 19999)
    test = b + i
    if isprime(test)
        if !frobenius(test)
            println("frobenius error at $test")
        end
    end
    if frobenius(test)
        if !isprime(test)
            println("frobenius error at $test")
        end
    end
end
println("end")
