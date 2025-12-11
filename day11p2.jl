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
    
    function count_paths(start, target)
        memo = Dict{String, BigInt}()
        
        function dfs(node)
            if node == target
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
                total += dfs(child)
            end
            memo[node] = total
            return total
        end
        
        return dfs(start)
    end
    
    fft_then_dac = count_paths("svr", "fft") * count_paths("fft", "dac") * count_paths("dac", "out")
    dac_then_fft = count_paths("svr", "dac") * count_paths("dac", "fft") * count_paths("fft", "out")
    
    return fft_then_dac + dac_then_fft
end

function solve_file(filename)
    return solve(read(filename, String))
end

example = """svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out"""

println("Example: ", solve(example), " (expected: 2)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve_file(ARGS[1]))
elseif isfile("input_day11.txt")
    println("Puzzle answer: ", solve_file("input_day11.txt"))
end
