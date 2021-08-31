using Plots
using Statistics

surf = [[] for i=1:200]
VarList = []
for n in 0:100
    randsurf = rand(1:200,1000)
    for i in randsurf
        append!(surf[i], n%10)
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
    append!(i, [3 for i=1:maxlen - length(i)])
end

theme(:dark)
gr()
heatmap(hcat(surf...), c = :solar, legend = false, border=:none)
savefig("C:\\Users\\Yaghoub\\Desktop\\Deposition\\Random-Ballistic-Deposition\\deposition.png")

scatter(VarList,
    xscale=:log,
    yscale=:log,
    ylims = (1,40),
    xticks=(1:20:101, 0:20:100),
    yticks=(1:5:40, 0:5:40),
    xlabel= "Time",
    ylabel= "W",
    title= "Log plot of W-Time",
    legend = nothing)
savefig("C:\\Users\\Yaghoub\\Desktop\\Deposition\\Random-Ballistic-Deposition\\log-scale.png")
