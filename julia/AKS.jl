using Hecke

function findr(n, max)
    #println("n: $n, max: $max")
    p = 1
    while true
        p = p + 1; a = n % p
        a == 0 && return (-1)
        tmp = a; isdivisor = false
        for i in range(1, max, step = 1)
            tmp == 1 && (isdivisor = true; break)
            tmp = mod(tmp*a, p)
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
    if r == -1
        return false
    end
    Rn = ResidueField(ZZ, n)
    Rx, x = Rn["x"]
    loops = Int64(floor(sqrt(euler_phi(r))*log2(n)))
    println("n: $n r: $r loop: $loops")
    pr = x^r - 1
    Ry = ResidueField(Rx, pr)
    zr1 = x^n
    for j in range(1, loops, step = 1)
        Ry(x + j)^n == zr1 + j && continue
        return false
    end
    return true
end

println("Test")
two = ZZ(2)
ten = ZZ(10)

a = ZZ(65537)
AKS(a) && println("$a is prime")