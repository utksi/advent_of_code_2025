function max_joltage(bank::AbstractString)
    n = length(bank)
    best = 0
    
    for i in 1:n-1
        first_digit = parse(Int, bank[i])
        second_digit = maximum(parse(Int, bank[j]) for j in i+1:n)
        joltage = first_digit * 10 + second_digit
        best = max(best, joltage)
    end
    
    return best
end

function solve(input::AbstractString)
    total = 0
    for line in split(strip(input), '\n')
        line = strip(line)
        isempty(line) && continue
        j = max_joltage(line)
        total += j
    end
    return total
end

function solve_file(filename)
    return solve(read(filename, String))
end

# Test with example
example = """
987654321111111
811111111111119
234234234234278
818181911112111
"""

for line in split(strip(example), '\n')
    println("  $line -> $(max_joltage(line))")
end
println("Example total: ", solve(example), " (expected: 357)")

# Solve actual puzzle
if length(ARGS) > 0
    println("\nPuzzle answer: ", solve_file(ARGS[1]))
else isfile("input_day3.txt")
    println("\nPuzzle answer: ", solve_file("input_day3.txt"))
end
