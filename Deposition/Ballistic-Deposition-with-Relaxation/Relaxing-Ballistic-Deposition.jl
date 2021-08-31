using Plots
using Statistics

surf = [[] for i=1:202]
VarList = []
for n in 1:100
    randsurf = rand(2:201,1000)
    for i in randsurf
        if i == 2 && length(surf[i]) >= length(surf[i-1]) - 2
            append!(surf[i-1], n%10)
        elseif i == 201 && length(surf[i]) >= length(surf[i+1]) - 2
            append!(surf[i+1], n%10)
        end
        len = Dict(length(surf[i-1])=>i-1,
            length(surf[i])=>i,
            length(surf[i+1])=>i+1,
            )
        minlen = min(length(surf[i-1]),length(surf[i]),length(surf[i+1]))
        append!(surf[len[minlen]], n%10)
    end
    SurfInTime = []
    for i in surf
        append!(SurfInTime, length(i))
    end
    append!(VarList,std(SurfInTime))
end

maxlen = 0
for i in surf
    if length(i) > maxlen
        maxlen = length(i)
    end
end

for i in surf
    append!(i, [1 for i=1:maxlen - length(i)])
end

theme(:dark)
gr()
heatmap(hcat(surf...), c = :solar, legend = false, border=:none)
savefig("C:\\Users\\Yaghoub\\Desktop\\Deposition\\Ballistic-Deposition-with-Relaxation\\deposition.png")

scatter(VarList,
    xscale=:log,
    yscale=:log,
    ylims = (0,5),
    xticks=(1:20:101, 0:20:100),
    yticks=(1:1:5, 0:1:5),
    xlabel= "Time",
    ylabel= "W",
    title= "Log plot of W-Time",
    legend = nothing)
savefig("C:\\Users\\Yaghoub\\Desktop\\Deposition\\Ballistic-Deposition-with-Relaxation\\log-scale.png")
