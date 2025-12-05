function solve(input::AbstractString)
    parts = split(strip(input), "\n\n")
    
    ranges = Tuple{Int,Int}[]
    for line in split(strip(parts[1]), '\n')
        a, b = split(strip(line), '-')
        push!(ranges, (parse(Int, a), parse(Int, b)))
    end
    
    sort!(ranges)
    
    merged = Tuple{Int,Int}[]
    for (lo, hi) in ranges
        if isempty(merged) || lo > merged[end][2] + 1
            push!(merged, (lo, hi))
        else
            prev_lo, prev_hi = merged[end]
            merged[end] = (prev_lo, max(prev_hi, hi))
        end
    end
    
    total = 0
    for (lo, hi) in merged
        total += hi - lo + 1
    end
    
    return total
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""

println("Example: ", solve(example), " (expected: 14)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day5.txt")
    println("Puzzle answer: ", solve_file("input_day5.txt"))
end
