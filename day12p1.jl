function parse_input(input::AbstractString)
    parts = split(strip(input), "\n\n")
    shapes = Vector{Vector{Tuple{Int,Int}}}()
    regions = Vector{Tuple{Int,Int,Vector{Int}}}()
    
    for part in parts
        lines = split(strip(part), '\n')
        first_line = lines[1]
        
        if occursin(r"^\d+:", first_line) && !occursin("x", first_line)
            shape = Tuple{Int,Int}[]
            for (r, line) in enumerate(lines[2:end])
                for (c, ch) in enumerate(line)
                    ch == '#' && push!(shape, (r, c))
                end
            end
            push!(shapes, shape)
        end
        
        for line in lines
            m = match(r"(\d+)x(\d+):\s*(.*)", line)
            if m !== nothing
                w, h = parse(Int, m.captures[1]), parse(Int, m.captures[2])
                counts = [parse(Int, x) for x in split(strip(m.captures[3]))]
                push!(regions, (w, h, counts))
            end
        end
    end
    shapes, regions
end

function normalize(shape)
    isempty(shape) && return Tuple{Int,Int}[]
    min_r = minimum(p[1] for p in shape)
    min_c = minimum(p[2] for p in shape)
    sort([(r - min_r, c - min_c) for (r, c) in shape])
end

function all_orientations(shape)
    rotate90(s) = [(-c, r) for (r, c) in s]
    flip(s) = [(r, -c) for (r, c) in s]
    
    orients = Set{Vector{Tuple{Int,Int}}}()
    current = shape
    for _ in 1:4
        push!(orients, normalize(current))
        push!(orients, normalize(flip(current)))
        current = rotate90(current)
    end
    collect(orients)
end

function solve_region(w, h, piece_list, all_orients)
    idx(r, c) = (r - 1) * w + c
    
    precomputed = Vector{Vector{UInt128}}()
    for shape_idx in piece_list
        placements = UInt128[]
        for orient in all_orients[shape_idx]
            max_r = maximum(dr for (dr, dc) in orient)
            max_c = maximum(dc for (dr, dc) in orient)
            for r in 1:(h - max_r)
                for c in 1:(w - max_c)
                    mask = UInt128(0)
                    for (dr, dc) in orient
                        mask |= UInt128(1) << (idx(r + dr, c + dc) - 1)
                    end
                    push!(placements, mask)
                end
            end
        end
        push!(precomputed, placements)
    end
    
    grid = Ref(UInt128(0))
    
    function backtrack(i)
        i > length(piece_list) && return true
        for mask in precomputed[i]
            if (grid[] & mask) == 0
                grid[] |= mask
                backtrack(i + 1) && return true
                grid[] &= ~mask
            end
        end
        false
    end
    
    backtrack(1)
end

function solve(input::AbstractString)
    shapes, regions = parse_input(input)
    all_orients = [all_orientations(s) for s in shapes]
    
    count = 0
    for (w, h, counts) in regions
        total = sum(length(shapes[i]) * counts[i] for i in 1:length(counts))
        total > w * h && continue
        
        piece_list = Int[]
        for (i, qty) in enumerate(counts)
            append!(piece_list, fill(i, qty))
        end
        sort!(piece_list, by = i -> -length(shapes[i]))
        
        solve_region(w, h, piece_list, all_orients) && (count += 1)
    end
    count
end

example = """0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2"""

println("Example: ", solve(example), " (expected: 2)")

if length(ARGS) > 0
    println("Puzzle answer: ", solve(read(ARGS[1], String)))
elseif isfile("input_day12.txt")
    println("Puzzle answer: ", solve(read("input_day12.txt", String)))
end
