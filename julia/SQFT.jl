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
        r = mod(r * r, n)
    end
    return r
end

function makeEpsilonList(e, n) 
    list = []
    append!(list, [one(e)])
    append!(list, [mod(- one(e), n)])
    append!(list, [e])
    append!(list, [mod(- e, n)])
    e2 = mod(e * e, n)
    append!(list, [e2])
    append!(list, [mod(- e2, n)])
    e3 = mod(e2 * e, n)
    append!(list,[e3])
    append!(list, [mod(- e3, n)])
    return list
end

function MR2(n)
    if n % 4 == 3
        alpha = powermod(ZZ(2), (n-3)>>2, n)
        tmp = (2*alpha*alpha) % n
        (tmp != 1) && (tmp != (n-1)) && return (false, 0, [])
        F, t = quadratic_field(-1)
        return (true, F, makeEpsilonList(F([alpha, alpha]), n))
    end
    if n % 8 == 5
        alpha = powermod(ZZ(2), (n-1)>>2, n)
        tmp = (alpha*alpha) % n
        (tmp != (n-1)) && return (false, 0, [])
        iseven(alpha) && (alpha += n)
        alpha=(alpha+1)>>1
        F, t = quadratic_field(2)
        return (true, F, makeEpsilonList(F([0, alpha]), n))
    end
    if n % 8 == 1
        c = ZZ(3)
        try_t=0
        while jacobi_symbol(c, n) != -1
            c = next_prime(c)
            try_t+=1
            if try_t > 16
              issquare(n) && return (false, 0, [])
              try_t = -1024
            end
        end
        alpha = powermod(c, (n-1)>>3, n)
        tmp = powermod(alpha, 4, n)
        (tmp != (n-1)) && return (false, 0, [])
        F, t = quadratic_field(c)
        return (true, F, makeEpsilonList(F([alpha, 0]), n))
    end
end

function SQFTRound(x, n, list)
    r = qfpowermod(x, n, n)
    tmp = qfconjmod(x, n)
    #println("1:$n: x:$x, r:$r, conj(x):$tmp")
    r != tmp && return false
    tmp = (n^2-1) >> 3
    (td, tr) = divrem(tmp, n)
    tmp1 = qfpowermod(r, td, n)
    tmp2 = qfpowermod(x, tr, n)
    r = mod(tmp1 * tmp2, n)
    #println("2: $n: $x, $r")
    return in(r, list)
end

function SQFT(n, t)
    Prm = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]  
    for p in Prm
        (n % p == 0) && return (n == p)
    end
    Q = append!([1], Prm)
    (r, F, list) = MR2(n)
    if r
        #println("MR2 True at $n: $F")
        #println("E: $list")
        i = 0
       for x in Q
            for y in Q
                if x != y
                    if SQFTRound(F([x, y]), n, list)
                        i = i + 1
                        (i > t) && return true                        
                    else
                        return false
                    end
                end
            end
       end 
    else
        return false
    end
end

########################################################

global b = ZZ(10)^67
@time for i in range(3, step = 2, stop = 19999)
    test = b + i
    isprime(test) && !SQFT(test, 1) && println("frobenius error at $test")
    SQFT(test, 1) && !isprime(test) && println("frobenius error at $test")
end
println("end")