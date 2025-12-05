function solve(input::AbstractString)
    parts = split(strip(input), "\n\n")
    
    ranges = Tuple{Int,Int}[]
    for line in split(strip(parts[1]), '\n')
        a, b = split(strip(line), '-')
        push!(ranges, (parse(Int, a), parse(Int, b)))
    end
    
    count = 0
    for line in split(strip(parts[2]), '\n')
        id = parse(Int, strip(line))
        for (lo, hi) in ranges
            if lo <= id <= hi
                count += 1
                break
            end
        end
    end
    
    return count
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

println("Example: ", solve(example), " (expected: 3)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day5.txt")
    println("Puzzle answer: ", solve_file("input_day5.txt"))
end
