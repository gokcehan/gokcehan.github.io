#!/usr/bin/env julia
#
# apen.jl
#
# Approximate entropy calculation
#

function apen(data, window, level)
    u = data
    N = length(u)

    phi = zeros(2)
    for k = 1:2
        m = window + (k - 1)
        r = level

        len = (N - m) + 1
        x = zeros(len, m)
        for i = 1:len
            for j = 1:m
                x[i,j] = u[(i+j)-1]
            end
        end

        C = zeros(len)
        for i = 1:len
            count = 0
            for j = 1:len
                if maximum(abs(x[i,:] - x[j,:])) < r
                    count += 1
                end
            end
            C[i] = count / len
        end

        phi[k] = sum(log(C)) / len
    end

    phi[1] - phi[2]
end

# example from wikipedia page:
# https://en.wikipedia.org/wiki/Approximate_entropy
u = repmat([85,80,89], 17)
m = 2
r = 3
println(apen(u, m, r))
