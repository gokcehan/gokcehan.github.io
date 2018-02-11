#!/usr/bin/env julia
#
# simplex.jl
#
# Basic simplex and tableau implementations
#

function simplex(A, b, c, bi)
    m, n = size(A)
    inds = IntSet(1 : n)
    ni = setdiff(inds, bi)

    while true
        B = A[:, collect(bi)]
        N = A[:, collect(ni)]
        cb = c[collect(bi), :]
        cn = c[collect(ni), :]
        z_c = zeros(n)

        # step 1
        xb = B \ b
        z = cb' * xb

        # step 2
        w = cb' * inv(B)
        z_c[collect(ni)] = w * N - cn'

        if all(i -> i <= 0, z_c)
            info("optimal solution is found")
            info("bi: $bi")
            x = zeros(n)
            x[collect(bi)] = xb
            info("x: $x")
            info("z: $z")
            return
        end

        k = indmax(z_c)

        # step 3
        yk = inv(B) * A[:, k]

        if all(i -> i <= 0, yk)
            info("optimal solution is unbounded")
            return
        end

        # step 4
        rs = fill(typemax(Float64), m)
        pos = find(i -> i > 0, yk)
        rs[pos] = xb[pos] ./ yk[pos]
        r = indmin(rs)
        br = collect(bi)[r]

        info("pivot: $k => $br")
        push!(bi, k)
        push!(ni, br)
        pop!(bi, br)
        pop!(ni, k)
    end
end

function simplex_tableau(A, b, c, bi)
    m, n = size(A)
    T = [1 -c' 0; zeros(length(bi)) A b]

    while true
        display(map(rationalize, T))
        println()
        println()

        # find entering variable k
        if all(i -> i <= 0, T[1, 2 : end - 1])
            info("optimal solution is found")
            return
        end
        k = indmax(T[1, 2 : end - 1])

        # find leaving variable r
        if all(i -> i <= 0, T[2 : end, k + 1])
            info("optimal solution is unbounded")
            return
        end
        rs = fill(typemax(Float64), m)
        pos = find(i -> i > 0, T[2 : end, k + 1])
        rs[pos] = T[pos, end] ./ T[pos, k + 1]
        r = indmin(rs)

        # pivot k and r
        T[r + 1, :] /= T[r + 1, k + 1]
        for i = 1 : m + 1
            if i == r + 1
                continue
            end
            T[i, :] -= T[i, k + 1] * T[r + 1, :]
        end

        info("pivot: $k => $r")
        println()
    end
end

using Base.Test

A = [2 3 1 0; -1 1 0 1]
b = [6 1]'
c = [-1 -3 0 0]'
bi = IntSet([3, 4])

simplex(A, b, c, bi)

A = [1 1 2 1 0 0; 1 1 -1 0 1 0; -1 1 1 0 0 1]
b = [9 2 4]'
c = [1 1 -4 0 0 0]'
bi = IntSet([4, 5, 6])

simplex_tableau(A, b, c, bi)
