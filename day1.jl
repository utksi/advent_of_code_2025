function solve(filename)
    position = 50
    count_zeros = 0
    
    for line in eachline(filename)
        line = strip(line)
        isempty(line) && continue
        
        direction = line[1]
        distance = parse(Int, line[2:end])
        
        if direction == 'L'
            position = mod(position - distance, 100)
        else  # direction == 'R'
            position = mod(position + distance, 100)
        end
        
        if position == 0
            count_zeros += 1
        end
    end
    
    return count_zeros
end

# Test with example
example = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""

function solve_string(input)
    position = 50
    count_zeros = 0
    
    for line in split(strip(input), '\n')
        line = strip(line)
        isempty(line) && continue
        
        direction = line[1]
        distance = parse(Int, line[2:end])
        
        if direction == 'L'
            position = mod(position - distance, 100)
        else
            position = mod(position + distance, 100)
        end
        
        if position == 0
            count_zeros += 1
        end
    end
    
    return count_zeros
end

println("Example test: ", solve_string(example), " (expected: 3)")

# Solve actual puzzle if input file exists
if length(ARGS) > 0
    println("Puzzle answer: ", solve(ARGS[1]))
elseif isfile("input.txt")
    println("Puzzle answer: ", solve("input.txt"))
else
    println("\nTo solve your puzzle, either:")
    println("  1. Run: julia day1.jl your_input.txt")
    println("  2. Place input in 'input.txt' and run: julia day1.jl")
end
