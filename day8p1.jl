struct UnionFind
    parent::Vector{Int}
    rank::Vector{Int}
    size::Vector{Int}
end

function UnionFind(n::Int)
    UnionFind(collect(1:n), zeros(Int, n), ones(Int, n))
end

function find!(uf::UnionFind, x::Int)
    if uf.parent[x] != x
        uf.parent[x] = find!(uf, uf.parent[x])
    end
    return uf.parent[x]
end

function union!(uf::UnionFind, x::Int, y::Int)
    px, py = find!(uf, x), find!(uf, y)
    if px == py
        return false
    end
    if uf.rank[px] < uf.rank[py]
        px, py = py, px
    end
    uf.parent[py] = px
    uf.size[px] += uf.size[py]
    if uf.rank[px] == uf.rank[py]
        uf.rank[px] += 1
    end
    return true
end

function solve(input::AbstractString)
    lines = split(strip(input), '\n')
    points = Vector{Tuple{Int,Int,Int}}()
    
    for line in lines
        parts = split(strip(line), ',')
        push!(points, (parse(Int, parts[1]), parse(Int, parts[2]), parse(Int, parts[3])))
    end
    
    n = length(points)
    
    edges = Vector{Tuple{Float64, Int, Int}}()
    for i in 1:n
        for j in i+1:n
            dx = points[i][1] - points[j][1]
            dy = points[i][2] - points[j][2]
            dz = points[i][3] - points[j][3]
            dist = sqrt(Float64(dx*dx + dy*dy + dz*dz))
            push!(edges, (dist, i, j))
        end
    end
    
    sort!(edges)
    
    uf = UnionFind(n)
    
    for idx in 1:min(1000, length(edges))
        dist, i, j = edges[idx]
        union!(uf, i, j)
    end
    
    sizes = Dict{Int, Int}()
    for i in 1:n
        root = find!(uf, i)
        sizes[root] = uf.size[root]
    end
    
    sorted_sizes = sort(collect(values(sizes)), rev=true)
    return sorted_sizes[1] * sorted_sizes[2] * sorted_sizes[3]
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689"""

function solve_example(input::AbstractString, num_connections::Int)
    lines = split(strip(input), '\n')
    points = Vector{Tuple{Int,Int,Int}}()
    
    for line in lines
        parts = split(strip(line), ',')
        push!(points, (parse(Int, parts[1]), parse(Int, parts[2]), parse(Int, parts[3])))
    end
    
    n = length(points)
    
    edges = Vector{Tuple{Float64, Int, Int}}()
    for i in 1:n
        for j in i+1:n
            dx = points[i][1] - points[j][1]
            dy = points[i][2] - points[j][2]
            dz = points[i][3] - points[j][3]
            dist = sqrt(Float64(dx*dx + dy*dy + dz*dz))
            push!(edges, (dist, i, j))
        end
    end
    
    sort!(edges)
    
    uf = UnionFind(n)
    
    for idx in 1:min(num_connections, length(edges))
        dist, i, j = edges[idx]
        union!(uf, i, j)
    end
    
    sizes = Dict{Int, Int}()
    for i in 1:n
        root = find!(uf, i)
        sizes[root] = uf.size[root]
    end
    
    sorted_sizes = sort(collect(values(sizes)), rev=true)
    return sorted_sizes[1] * sorted_sizes[2] * sorted_sizes[3]
end

println("Example (10 connections): ", solve_example(example, 10), " (expected: 40)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day8.txt")
    println("Puzzle answer: ", solve_file("input_day8.txt"))
end
