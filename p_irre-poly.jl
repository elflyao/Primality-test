using MPI
using Hecke

function do_root(comm, nworkers)
    currwoker = 1
    for p in range(827, step=2, stop=1023)
        if isprime(p)
            for n in range(2, p - 1)
                send_msg = Array([p, n])
                MPI.Isend(send_msg, currwoker, tag=0, comm)
                currworker = currwoker + 1
                if currworker > nworkers
                    currworker = 1
                end
            end
            MPI.Barrier(comm)
        end
    end
end

function do_work(comm)
    MPI.Irecv!(recv_msg, root, tag=0, comm)
    p = recv_msg[1]
    n = recv_msg[2]
    Qx, x = QQ["x"]
    f = x^p + n * x + 1
    if isirreducible(f)
        println("x^$p + $n x + 1 is irreducible!")
    end
end

function jobs()
    MPI.Init()

    comm = MPI.COMM_WORLD
    rank = MPI.Comm_rank(comm)
    world_size = MPI.Comm_size(comm)
    nworkers = world_size - 1
    root = 0

    MPI.Barrier(comm)
    T = eltype(data)
    N = size(data)[1]
    send_mesg = Array{T}(undef, 1)
    recv_mesg = Array{T}(undef, 1)

    if rand == root
        do_root(comm, nworkers)
    else
        do_work(comm)
    end
    MPI.Barrier(comm)
    MPI.Finalize()
end