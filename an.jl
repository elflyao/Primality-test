using Hecke

setprecision(10000)

function seq_a(n)
    global a = big(1)
    global b = big(11.0)
    for i in range(1, n)
        tmp = 4 * a + BigInt(floor(a *  sqrt(b)))
        global a = tmp 
    end
    a
end

function seq_b(n)
    d = 11
    F, t = quadratic_field(d)
    b_1 = 4 - t
    b_2 = 4 + t
    t_1 = 33 + 7t
    t_2 = 5(11 + 3t)
    t_3 = 110b_2
    b = (t_1 * b_1^n + t_2 * b_2^n) / t_3
    b
end

for n in range(1,1000)
    if seq_a(n) != seq_b(n+1)
        println(n)
        println(seq_a(n))
        println(seq_b(n+1))
    end
end

