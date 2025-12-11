using JuMP
using HiGHS

function parse_machine(line)
    buttons = Vector{Vector{Int}}()
    for m in eachmatch(r"\(([0-9,]*)\)", line)
        if isempty(m.captures[1])
            push!(buttons, Int[])
        else
            push!(buttons, [parse(Int, x) for x in split(m.captures[1], ",")])
        end
    end
    
    target_match = match(r"\{([0-9,]+)\}", line)
    target = [parse(Int, x) for x in split(target_match.captures[1], ",")]
    
    return target, buttons
end

function solve_machine(target, buttons)
    n = length(target)
    m = length(buttons)
    
    if m == 0
        return all(t == 0 for t in target) ? 0 : -1
    end
    
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    
    @variable(model, x[1:m] >= 0, Int)
    
    A = zeros(Int, n, m)
    for j in 1:m
        for counter in buttons[j]
            if counter + 1 <= n
                A[counter + 1, j] = 1
            end
        end
    end
    
    for i in 1:n
        @constraint(model, sum(A[i, j] * x[j] for j in 1:m) == target[i])
    end
    
    @objective(model, Min, sum(x))
    
    optimize!(model)
    
    if termination_status(model) == MOI.OPTIMAL
        return Int(round(objective_value(model)))
    else
        return -1
    end
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
println("Example total: ", solve(example), " (expected: 33)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day10.txt")
    println("Puzzle answer: ", solve_file("input_day10.txt"))
end
