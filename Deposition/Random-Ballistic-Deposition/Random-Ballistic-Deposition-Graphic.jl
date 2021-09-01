using Plots
using Statistics

function Leveling(surface)
    maxlen = 0
    surf = surface
    for i in surf
        if length(i) > maxlen
            maxlen = length(i)
        end
    end
    for i in surf
        append!(i, [3 for i=1:maxlen - length(i)])
    end
    return surf
end

function Deposition_2DG(len, tot_time, rate, color_step)
    surf = [[] for i=1:len]
    for n in 0:tot_time
        randsurf = rand(1:len,rate)
        for i in randsurf
            append!(surf[i], n%color_step)
        end
    end
    return Leveling(surf)
end

theme(:dark)
gr()

surf = Deposition_2DG(200, 100, 10000, 10)

heatmap(hcat(surf...), c = :solar, legend = false)
savefig("C:\\Users\\Yaghoub\\Documents\\GitHub\\Ballistic-Deposition\\Deposition\\Random-Ballistic-Deposition\\Fig\\deposition.png")
