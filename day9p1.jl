function solve(input::AbstractString)
    lines = split(strip(input), '\n')
    tiles = Vector{Tuple{Int,Int}}()
    
    for line in lines
        parts = split(strip(line), ',')
        push!(tiles, (parse(Int, parts[1]), parse(Int, parts[2])))
    end
    
    n = length(tiles)
    max_area = 0
    
    for i in 1:n
        for j in i+1:n
            width = abs(tiles[i][1] - tiles[j][1]) + 1
            height = abs(tiles[i][2] - tiles[j][2]) + 1
            area = width * height
            max_area = max(max_area, area)
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

println("Example: ", solve(example), " (expected: 50)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day9.txt")
    println("Puzzle answer: ", solve_file("input_day9.txt"))
end
