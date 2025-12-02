#=
day 2: gift shop solution -part 2
------------------------------------
=#

"""
    is_invalid_id_part2(n::Int)
"""
function is_invalid_id_part2(n::Int)
    s = string(n)
    L = length(s)
    
    for unit_len in 1:(L ÷ 2)
        if L % unit_len == 0
            pattern = SubString(s, 1, unit_len)
            repeats = L ÷ unit_len
            
            if repeat(pattern, repeats) == s
                return true
            end
        end
    end
    
    return false
end

"""
    solve_gift_shop_part2(input_str::String)
"""
function solve_gift_shop_part2(input_str::String)
    clean_input = replace(input_str, "\n" => "", " " => "")
    
    range_strs = split(clean_input, ",")
    total_sum = 0
    
    for r_str in range_strs
        if isempty(r_str) continue end
        
        parts = split(r_str, "-")
        range_start = parse(Int, parts[1])
        range_end = parse(Int, parts[2])
        
        for id in range_start:range_end
            if is_invalid_id_part2(id)
                total_sum += id
            end
        end
    end
    
    return total_sum
end

if length(ARGS) < 1
    println("No input fil.")
    exit(1)
end

filename = ARGS[1]

if isfile(filename)
    input_data = read(filename, String)
    
    result = solve_gift_shop_part2(input_data)

    println(result)
else
    println("File '$filename' not found.")
    exit(1)
end
