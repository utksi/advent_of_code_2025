#=
day 2: gift shp solution
-------------------------
=#

"""
is_invalid_id(n::Int)
"""
function is_invalid_id(n::Int)
    s = string(n)
    len = length(s)
    
    if len % 2 != 0
        return false
    end
    
    half_len = len ÷ 2
    first_half = SubString(s, 1, half_len)
    second_half = SubString(s, half_len + 1, len)
    
    return first_half == second_half
end

"""
    solve_gift_shop(input_str::String)
"""
function solve_gift_shop(input_str::String)
    clean_input = replace(input_str, "\n" => "", " " => "")
    
    range_strs = split(clean_input, ",")
    total_sum = 0
    
    for r_str in range_strs
        if isempty(r_str) continue end
        
        parts = split(r_str, "-")
        range_start = parse(Int, parts[1])
        range_end = parse(Int, parts[2])
        
        for id in range_start:range_end
            if is_invalid_id(id)
                total_sum += id
            end
        end
    end
    
    return total_sum
end

if length(ARGS) < 1
    println("No input.")
    exit(1)
end

filename = ARGS[1]

if isfile(filename)
    input_data = read(filename, String)
    
    result = solve_gift_shop(input_data)

    println(result)
else
    println("File '$filename' not found.")
    exit(1)
end
