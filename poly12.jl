using Distributed
using Hecke

Qx, x = QQ["x"]
const t4 = [-1, 1]
const one2 = [-1, 1]

for p in range(3, 31)
    println("$p: ")
    for a in t4
        for b in one2
            if mod(p, 2) == 1
                if abs(a) == 2
                    continue
                end
            end
            f = x^p + a * x + b
            if !isirreducible(f)
                println("$f is reducible!")
            end
        end
    end
end

