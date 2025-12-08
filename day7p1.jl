function solve(input::AbstractString)
    lines = split(strip(input), '\n')
    grid = [collect(line) for line in lines]
    rows = length(grid)
    cols = length(grid[1])
    
    start_col = 0
    for c in 1:cols
        if grid[1][c] == 'S'
            start_col = c
            break
        end
    end
    
    active_beams = Set{Int}([start_col])
    split_count = 0
    
    for r in 2:rows
        new_beams = Set{Int}()
        for c in active_beams
            if grid[r][c] == '^'
                split_count += 1
                if c > 1
                    push!(new_beams, c - 1)
                end
                if c < cols
                    push!(new_beams, c + 1)
                end
            else
                push!(new_beams, c)
            end
        end
        active_beams = new_beams
    end
    
    return split_count
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."""

println("Example: ", solve(example), " (expected: 21)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day7.txt")
    println("Puzzle answer: ", solve_file("input_day7.txt"))
end
