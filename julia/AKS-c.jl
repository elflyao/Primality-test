using Hecke

function nfpowermod(x, p , n)
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

function findr(n, max)
    #println("n: $n, max: $max")
    primeList = []
    for p in PrimesSet(2, max)
        push!(primeList, p)
    end

    for p in primeList
        a = n % p
        a == 0 && return (-1)
        tmp = a; isdivisor = false
        for i in range(1, max, step = 1)
            tmp == 1 && (isdivisor = true; break)
            tmp = tmp * a % p
        end
        isdivisor && continue
        return p
    end
    p = max
    while true
        p = next_prime(p); a = n % p
        a == 0 && return (-1)
        tmp = a; isdivisor = false
        for i in range(1, max, step = 1)
            tmp == 1 && (isdivisor = true; break)
            tmp = tmp * a % p
        end
        isdivisor && continue
        return p
    end
end

function AKS(n)
    #这里可以用多次Miller-Rabin测试来保证n不是幂
    if is_perfect_power(n)
        return false
    end
    max = Int64(floor(log2(n)^2))
    r = findr(n, max)
    println("r: $r")
    if r == -1
        return false
    end
    C, zr = cyclotomic_field(r)
    loops = Int64(floor(sqrt(euler_phi(r))*log2(n)))
    zr1 = nfpowermod(zr, n, n)
    for j in range(1, loops, step = 1)
        zj = zr + j
        ztmp = nfpowermod(zj, n, n)
        ztmp == mod(zr1 + j, n) && continue
        return false
    end
    return true
end

println("Test")
two = ZZ(2)
ten = ZZ(10)

a = 65537
AKS(a) && println("$a is prime")

a = 2^31-1
AKS(a) && println("$a is prime")

