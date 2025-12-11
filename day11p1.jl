function solve(input::AbstractString)
    graph = Dict{String, Vector{String}}()
    
    for line in split(strip(input), '\n')
        line = strip(line)
        isempty(line) && continue
        parts = split(line, ": ")
        src = parts[1]
        dests = length(parts) > 1 ? split(parts[2]) : String[]
        graph[src] = collect(dests)
    end
    
    memo = Dict{String, BigInt}()
    
    function count_paths(node)
        if node == "out"
            return BigInt(1)
        end
        if haskey(memo, node)
            return memo[node]
        end
        if !haskey(graph, node)
            return BigInt(0)
        end
        
        total = BigInt(0)
        for child in graph[node]
            total += count_paths(child)
        end
        memo[node] = total
        return total
    end
    
    return count_paths("you")
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out"""

println("Example: ", solve(example), " (expected: 5)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day11.txt")
    println("Puzzle answer: ", solve_file("input_day11.txt"))
end
