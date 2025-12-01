function count_zeros_left(pos, distance)
    if pos == 0
        return distance ÷ 100
    elseif distance >= pos
        return (distance - pos) ÷ 100 + 1
    else
        return 0
    end
end

function count_zeros_right(pos, distance)
    if pos == 0
        return distance ÷ 100
    else
        first_zero = 100 - pos
        if distance >= first_zero
            return (distance - first_zero) ÷ 100 + 1
        else
            return 0
        end
    end
end

function solve_part2(input)
    position = 50
    total_zeros = 0
    
    for line in split(strip(input), '\n')
        line = strip(line)
        isempty(line) && continue
        
        direction = line[1]
        distance = parse(Int, line[2:end])
        
        if direction == 'L'
            total_zeros += count_zeros_left(position, distance)
            position = mod(position - distance, 100)
        else  # 'R'
            total_zeros += count_zeros_right(position, distance)
            position = mod(position + distance, 100)
        end
    end
    
    return total_zeros
end

function solve_file(filename)
    return solve_part2(read(filename, String))
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

println("Example test: ", solve_part2(example), " (expected: 6)")

# Test the R1000 edge case
test_r1000 = "R1000"
println("R1000 from 50 test: ", solve_part2(test_r1000), " (expected: 10)")

# Solve actual puzzle
if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day1.txt")
    println("Puzzle answer: ", solve_file("input_day1.txt"))
else
    println("\nTo solve: julia day1_part2.jl your_input.txt")
end
