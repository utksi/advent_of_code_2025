function solve(input::AbstractString)
    lines = split(strip(input), '\n')
    red_tiles = Vector{Tuple{Int,Int}}()
    
    for line in lines
        parts = split(strip(line), ',')
        push!(red_tiles, (parse(Int, parts[1]), parse(Int, parts[2])))
    end
    
    n = length(red_tiles)
    
    vertical_edges = Vector{Tuple{Int,Int,Int}}()
    for i in 1:n
        j = i % n + 1
        x1, y1 = red_tiles[i]
        x2, y2 = red_tiles[j]
        if x1 == x2
            push!(vertical_edges, (x1, min(y1, y2), max(y1, y2)))
        end
    end
    
    ys = sort(unique(t[2] for t in red_tiles))
    y_to_idx = Dict(y => i for (i, y) in enumerate(ys))
    m = length(ys)
    
    left_arr = Vector{Int}(undef, m)
    right_arr = Vector{Int}(undef, m)
    
    for (idx, y) in enumerate(ys)
        l, r = typemax(Int), typemin(Int)
        for (x, y_min, y_max) in vertical_edges
            if y_min <= y <= y_max
                l = min(l, x)
                r = max(r, x)
            end
        end
        left_arr[idx] = l
        right_arr[idx] = r
    end
    
    log_m = max(1, ceil(Int, log2(m)))
    max_left = fill(typemin(Int), m, log_m + 1)
    min_right = fill(typemax(Int), m, log_m + 1)
    
    for i in 1:m
        max_left[i, 1] = left_arr[i]
        min_right[i, 1] = right_arr[i]
    end
    
    for j in 2:log_m+1
        len = 1 << (j - 1)
        for i in 1:m - len + 1
            max_left[i, j] = max(max_left[i, j-1], max_left[i + len ÷ 2, j-1])
            min_right[i, j] = min(min_right[i, j-1], min_right[i + len ÷ 2, j-1])
        end
    end
    
    function query(i1, i2)
        if i1 > i2
            i1, i2 = i2, i1
        end
        len = i2 - i1 + 1
        k = floor(Int, log2(len))
        ml = max(max_left[i1, k+1], max_left[i2 - (1 << k) + 1, k+1])
        mr = min(min_right[i1, k+1], min_right[i2 - (1 << k) + 1, k+1])
        return ml, mr
    end
    
    max_area = 0
    
    for i in 1:length(red_tiles)
        for j in i+1:length(red_tiles)
            x1, y1 = red_tiles[i]
            x2, y2 = red_tiles[j]
            
            lx, rx = min(x1, x2), max(x1, x2)
            idx1, idx2 = y_to_idx[y1], y_to_idx[y2]
            
            ml, mr = query(idx1, idx2)
            
            if ml <= lx && mr >= rx
                width = rx - lx + 1
                height = abs(y2 - y1) + 1
                area = width * height
                max_area = max(max_area, area)
            end
        end
    end
    
    return max_area
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3"""

println("Example: ", solve(example), " (expected: 24)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day9.txt")
    println("Puzzle answer: ", solve_file("input_day9.txt"))
end
