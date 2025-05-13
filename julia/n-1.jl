using Hecke

function factorList(m)
    lst = []
    f = factor(m)
    for d in f
        append!(lst, BigInt(d.first))
    end
    return lst
end

function ns1prov(n)
    a = 2
    lst = factorList(n-1)
    while true
        if powermod(a, n-1, n) != 1
            return false
        end
        all = true
        for r in lst
            if powermod(a, div(n-1, r), n) == 1
                all = false
                break
            end
        end
        if all
            #println("$n: $a")
            return true
        end
        a = a + 1
    end
end

for t in range(60001, stop=70000, step=1)
    isprime(t) && !ns1prov(t) && println("n-1 prov error on $t")
    !isprime(t) && ns1prov(t) && println("n-1 prov error on $t")
end

println("341:", ns1prov(341))
println("561:", ns1prov(561))
println("2^47-1:", ns1prov(2^47-1))
println("2^61-1:", ns1prov(2^61-1))
println("2^127+45:", ns1prov(big(2)^127+45))
