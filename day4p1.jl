function solve(input::AbstractString)
    lines = split(strip(input), '\n')
    grid = [collect(strip(line)) for line in lines]
    rows = length(grid)
    cols = length(grid[1])
    
    directions = [(-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)]
    
    count = 0
    for r in 1:rows
        for c in 1:cols
            if grid[r][c] == '@'
                neighbors = 0
                for (dr, dc) in directions
                    nr, nc = r + dr, c + dc
                    if 1 <= nr <= rows && 1 <= nc <= cols && grid[nr][nc] == '@'
                        neighbors += 1
                    end
                end
                if neighbors < 4
                    count += 1
                end
            end
        end
    end
    
    return count
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"""

println("Example: ", solve(example), " (expected: 13)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day4.txt")
    println("Puzzle answer: ", solve_file("input_day4.txt"))
end
