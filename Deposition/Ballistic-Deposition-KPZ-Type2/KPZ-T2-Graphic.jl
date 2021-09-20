using Plots, LaTeXStrings, Statistics

function Deposition_2DG(; len, tot_time, dep_rate, color_step)
    surface = InitialSurf(200)
    for n in 0:tot_time
        randsurf = rand(1:len, dep_rate)
        for i in randsurf
            i1 , i2 = sides(i, len)
            if surface[end][i] != 0
                newsurf = [0 for j = 1:len]
                newsurf[i] = (n%color_step) + 1
                push!(surface, newsurf)
            end
            for num in 0:length(surface) -1
                if surface[end - num][i] == 0 && (surface[end - num][i1] != 0 || surface[end - num][i2] != 0)
                    surface[end - num][i] = (n%color_step) + 1
                    break
                elseif length(surface) > num + 1 && surface[end - 1 - num][i] != 0
                    surface[end - num][i] = (n%color_step) + 1
                    break
                end
            end
        end
    end
    return surface
end

function sides(n, L)
    if n == L
        return n-1 , 1
    elseif n == 1
        return L , n+1
    else
        return n-1, n+1
    end
end

function InitialSurf(len)
    pos1 = [0 for i=1:len]
    pos1[floor(Int, len/2)] = 1
    return [pos1]
end

Parameters = Dict(:len => 200,
                    :tot_time => 800,
                        :dep_rate => 40,
                            :color_step => 100)

surf = Deposition_2DG(;Parameters...)

theme(:dark)
gr()

heatmap(transpose(hcat(surf...)), c = :solar, legend = false)
savefig("C:\\Users\\Yaghoub\\Documents\\GitHub\\Ballistic-Deposition\\Deposition\\Ballistic-Deposition-KPZ-Type2\\Fig\\deposition.png")
