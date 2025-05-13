using Distributed
addprocs(24)

@everywhere begin
    using Hecke
    Qx, x = QQ["x"]
end

a = parse(Int64, ARGS[1])
b = parse(Int64, ARGS[2])

for p in range(a, step=2, stop=b)
    if isprime(p)
        println("$p: ")
        @sync @distributed for n in range(2, p - 1)
            f = x^p + n * x + 1
            if !isirreducible(f)
                println("x^$p + $n x + 1 is reducible!")
            end
        end
    end
end

