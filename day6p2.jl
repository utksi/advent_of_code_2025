function solve(input::AbstractString)
    lines = split(rstrip(input), '\n')
    rows = length(lines)
    cols = maximum(length(line) for line in lines)
    
    grid = fill(' ', rows, cols)
    for (r, line) in enumerate(lines)
        for (c, ch) in enumerate(line)
            grid[r, c] = ch
        end
    end
    
    separator_cols = Set{Int}()
    for c in 1:cols
        if all(grid[r, c] == ' ' for r in 1:rows)
            push!(separator_cols, c)
        end
    end
    
    problems = Vector{Vector{Int}}()
    current_cols = Int[]
    for c in 1:cols
        if c in separator_cols
            if !isempty(current_cols)
                push!(problems, current_cols)
                current_cols = Int[]
            end
        else
            push!(current_cols, c)
        end
    end
    if !isempty(current_cols)
        push!(problems, current_cols)
    end
    
    total = BigInt(0)
    for prob_cols in problems
        op = ' '
        for c in prob_cols
            if grid[rows, c] in ['+', '*']
                op = grid[rows, c]
                break
            end
        end
        
        numbers = Int[]
        for c in reverse(prob_cols)
            digits = Char[]
            for r in 1:rows-1
                if grid[r, c] != ' '
                    push!(digits, grid[r, c])
                end
            end
            if !isempty(digits)
                push!(numbers, parse(Int, join(digits)))
            end
        end
        
        if op == '+'
            result = sum(numbers)
        else
            result = prod(BigInt.(numbers))
        end
        total += result
    end
    
    return total
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  """

println("Example: ", solve(example), " (expected: 3263827)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day6.txt")
    println("Puzzle answer: ", solve_file("input_day6.txt"))
end
