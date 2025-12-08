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
        numbers = Int[]
        for r in 1:rows-1
            s = join([grid[r, c] for c in prob_cols])
            s = strip(s)
            if !isempty(s)
                push!(numbers, parse(Int, s))
            end
        end
        
        op_row = join([grid[rows, c] for c in prob_cols])
        op = strip(op_row)[1]
        
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

println("Example: ", solve(example), " (expected: 4277556)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day6.txt")
    println("Puzzle answer: ", solve_file("input_day6.txt"))
end
