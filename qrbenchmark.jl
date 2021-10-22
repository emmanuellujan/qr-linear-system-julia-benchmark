using LinearAlgebra, CSV, DataFrames

#function solve(A, B)
#    A \ B
##    qr(A,Val(true)) \ B
##    qr(A) \ B
##    A' * A \ A' * B # cond(A' * A) >> cond(A) => not convinient
##    pinv(A) * B
#end

function benchmark(f)
    rows = 1000:1000:5000
    cols = 30:10:100
    num_sizes = size(rows)[1] * size(cols)[1]
    nexp = 100
    sizes = zeros(num_sizes)
    times = zeros(num_sizes)
    i = 1
    for r = rows
        for c = cols
            s = 0.0
            for e = 1:nexp
                A = randn(r, c)
                B = randn(r, 1)
                s += (@timed f(A, B)).time
            end
            sizes[i] = r * c
            times[i] = s / nexp
            i += 1
        end
    end
    #sp = sortperm(collect(zip(sizes, times)))
    #return sizes[sp], times[sp]
    return sizes, times
end

f(A, B) = qr(A,Val(true)) \ B
sizes, times = benchmark(f)
filename = "julia-qr.csv"
if !isfile(filename)
    CSV.write(filename,  DataFrame([sizes, times], :auto), writeheader=false)
end

f(A, B) = pinv(A) * B
sizes, times = benchmark(f)
filename = "julia-pinv.csv"
if !isfile(filename)
    CSV.write(filename,  DataFrame([sizes, times], :auto), writeheader=false)
end


