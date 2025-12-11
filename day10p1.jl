function parse_machine(line)
    target_match = match(r"\[([.#]+)\]", line)
    target = [c == '#' ? 1 : 0 for c in target_match.captures[1]]
    
    buttons = Vector{Vector{Int}}()
    for m in eachmatch(r"\(([0-9,]*)\)", line)
        if isempty(m.captures[1])
            push!(buttons, Int[])
        else
            push!(buttons, [parse(Int, x) for x in split(m.captures[1], ",")])
        end
    end
    
    return target, buttons
end

function solve_machine(target, buttons)
    n = length(target)
    m = length(buttons)
    
    if m == 0
        return all(t == 0 for t in target) ? 0 : -1
    end
    
    aug = zeros(Int, n, m + 1)
    
    for j in 1:m
        for light in buttons[j]
            aug[light + 1, j] = 1
        end
    end
    for i in 1:n
        aug[i, m + 1] = target[i]
    end
    
    pivot_cols = Int[]
    row = 1
    for col in 1:m
        pivot_row = 0
        for r in row:n
            if aug[r, col] == 1
                pivot_row = r
                break
            end
        end
        
        if pivot_row == 0
            continue
        end
        
        aug[row, :], aug[pivot_row, :] = aug[pivot_row, :], copy(aug[row, :])
        
        for r in 1:n
            if r != row && aug[r, col] == 1
                for c in 1:m+1
                    aug[r, c] = xor(aug[r, c], aug[row, c])
                end
            end
        end
        
        push!(pivot_cols, col)
        row += 1
    end
    
    for r in row:n
        if aug[r, m + 1] == 1
            return -1
        end
    end
    
    free_cols = setdiff(1:m, pivot_cols)
    num_free = length(free_cols)
    
    pivot_row_for_col = Dict{Int,Int}()
    for (r, col) in enumerate(pivot_cols)
        pivot_row_for_col[col] = r
    end
    
    min_presses = m + 1
    
    for mask in 0:(2^num_free - 1)
        x = zeros(Int, m)
        
        for (i, col) in enumerate(free_cols)
            x[col] = (mask >> (i - 1)) & 1
        end
        
        for col in reverse(pivot_cols)
            r = pivot_row_for_col[col]
            val = aug[r, m + 1]
            for c in col+1:m
                val = xor(val, aug[r, c] * x[c])
            end
            x[col] = val
        end
        
        presses = sum(x)
        min_presses = min(min_presses, presses)
    end
    
    return min_presses
end

function solve(input::AbstractString)
    total = 0
    for line in split(strip(input), '\n')
        line = strip(line)
        isempty(line) && continue
        target, buttons = parse_machine(line)
        presses = solve_machine(target, buttons)
        total += presses
    end
    return total
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"""

println("Testing individual machines:")
for line in split(strip(example), '\n')
    target, buttons = parse_machine(line)
    presses = solve_machine(target, buttons)
    println("  ", presses, " presses")
end
println("Example total: ", solve(example), " (expected: 7)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day10.txt")
    println("Puzzle answer: ", solve_file("input_day10.txt"))
end
