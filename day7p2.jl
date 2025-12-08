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
    
    timelines = Dict{Int, BigInt}(start_col => 1)
    
    for r in 2:rows
        new_timelines = Dict{Int, BigInt}()
        for (c, count) in timelines
            if grid[r][c] == '^'
                if c > 1
                    new_timelines[c - 1] = get(new_timelines, c - 1, BigInt(0)) + count
                end
                if c < cols
                    new_timelines[c + 1] = get(new_timelines, c + 1, BigInt(0)) + count
                end
            else
                new_timelines[c] = get(new_timelines, c, BigInt(0)) + count
            end
        end
        timelines = new_timelines
    end
    
    return sum(values(timelines))
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

println("Example: ", solve(example), " (expected: 40)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day7.txt")
    println("Puzzle answer: ", solve_file("input_day7.txt"))
end
