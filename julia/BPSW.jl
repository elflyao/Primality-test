using Hecke

function fibonacciTest(n)
    r = n % 5
    r == 0 && return false
    if r == 1 || r == 4 
        j = 1
    end
    if r == 2 || r == 3
        j = -1
    end
    return fibonacci(n-j) % n == 0
end

function millerRabbinTest(n, b)
    k = trailing_zeros(n-1)
    m = (n-1) >> k
    a = powermod(b, m, n)
    if (a == 1) || (a == (n-1))
        return true
    else
        for i in 1:k-1
            a = powermod(a, 2, n)
            if a == n - 1
                return true
            end
        end
    end
    return false
end

function lucasSeq(p, q, t)
    ua, ub = 0, 1
    va, vb =  2, p
    u = []
    v = []
    for  i in 1:t
        push!(u, ub)
        t = p*ub - q*ua
        ua, ub = ub, t
        push!(v, vb)
        t = p*vb - q*va
        va, vb = vb, t
    end
    println(u)
    println(v)
end

function selectParam(n)
    d = 5
    delta = 2
    t = 0
    while jacobi_symbol(d, n) != -1
        delta = -delta
        d = delta - d
    end
    p, q = 1, div((1 - d), 4)
    return q == -1 ? (5, 5, 5) : (d, p, q)
end

function lucasDouble(u, v, q, n)
    u = mod(u * v,  n)
    v = mod(v * v - 2 * q ,  n)
    q = mod(q * q, n)
    return (u, v, q)
end

function lucasNext(u, v, d, p, q, q1, n)
    t = u
    u = mod(p*u + v, n)
    isodd(u) && (u=u+n)
    u=u>>1
    v = mod(d*t + p*v, n)
    isodd(v) && (v=v+n)
    v=v>>1
    q = mod(q * q1, n)
    return (u, v, q)
end

function strongLucasTest(n)
    (d, p, q) = selectParam(n)
    q1 = q
    (u, v, q) = (0, 2, 1)
    k = trailing_zeros(n+1)
    m = (n+1) >> k
    for b in bits(ZZ(m))
        (u, v, q) = lucasDouble(u, v, q, n)
        if  b
            (u, v, q) = lucasNext(u, v, d, p, q, q1, n)
        end
    end
    if u != 0
        for r in 0:k-1
            if v!= 0
                v = mod(v * v - 2 * q ,  n)
                q = mod(q * q, n)
            else
                return (true, v, q, r, k, q1)
            end        
        end
        return (false, 0, 0, 0, 0, 0)
    else
        return (true, v, q, 0, k, q1)
    end
end

function BPSW(n)
    !millerRabbinTest(n, 2) && return false
    (f, _, _, _, _, _) = strongLucasTest(n) 
    !f && return false
    return true
end

function enhancedStrongLucasTest(n)
    (f, v, q, r, k, q1) = strongLucasTest(n)
    !f && return false
     for i in r+1:k-1
        v = mod(v * v - 2 * q ,  n)
        q = mod(q * q, n)
    end
    v = mod(v * v - 2 * q ,  n)
    v !=  mod(2*q1, n) && return false
    q != mod(q1*jacobi_symbol(q1, n), n) && return false
    return true
end

function EBPSW(n)
    !millerRabbinTest(n, 2) && return false
    !millerRabbinTest(n, 3) && return false
    !enhancedStrongLucasTest(n) && return false
    return true
end

for i in range(ZZ(7), stop=ZZ(999999), step=2)

    if fibonacciTest(i)
       if !isprime(i)
            println("Fibonacci Pseudoprime: $i")
        end
    end

    if isprime(i)
        if !fibonacciTest(i)
            println("Fibonacci Primality test error at: $i")
        end
    end
end

for i in range(3, stop=999999, step=2)

    if BPSW(i)
        if !isprime(i)
            println("BPSWPseudoprime: $i")
        end
    end

    if isprime(i)
        if !BPSW(i)
            println("BPSW Primality test error at: $i")
        end
    end
end

for i in range(5, stop=999999, step=2)

    if EBPSW(i)
        if !isprime(i)
            println("EBPSW Pseudoprime: $i")
        end
    end

    if isprime(i)
        if !EBPSW(i)
           println("EBPSW Primality test error at: $i")
        end
    end
end

println("end")