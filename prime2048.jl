using Hecke
using Printf

global i = 0
for p in range(31, step=2, stop=2047)
    if isprime(p)
        @printf "%4d," p
        global i = i + 1
        if i % 20 == 0
            println()
        end
    end
end
println()