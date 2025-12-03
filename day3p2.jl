function max_joltage_12(bank::AbstractString)
    n = length(bank)
    digits_needed = 12
    result = Int[]
    start = 1
    
    for i in 1:digits_needed
        remaining = digits_needed - i + 1
        # Can pick from start to n - remaining + 1
        end_pos = n - remaining + 1
        
        # Find position of max digit in range
        best_digit = -1
        best_pos = start
        for j in start:end_pos
            d = parse(Int, bank[j])
            if d > best_digit
                best_digit = d
                best_pos = j
            end
        end
        
        push!(result, best_digit)
        start = best_pos + 1
    end
    
    # Convert digits to number
    joltage = BigInt(0)
    for d in result
        joltage = joltage * 10 + d
    end
    return joltage
end

function solve(input::AbstractString)
    total = BigInt(0)
    for line in split(strip(input), '\n')
        line = strip(line)
        isempty(line) && continue
        j = max_joltage_12(line)
        total += j
    end
    return total
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """
987654321111111
811111111111119
234234234234278
818181911112111
"""

println("Testing individual banks:")
for line in split(strip(example), '\n')
    println("  $line -> $(max_joltage_12(line))")
end
println("Example total: ", solve(example), " (expected: 3121910778619)")

if length(ARGS) > 0
    println("\nPuzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day3.txt")
    println("\nPuzzle answer: ", solve_file("input_day3.txt"))
else
    println("\nTo solve: julia day3_part2.jl input_day3.txt")
end
