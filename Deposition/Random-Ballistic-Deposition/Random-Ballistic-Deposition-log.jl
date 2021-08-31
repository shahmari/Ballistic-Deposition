using Plots
using Statistics
tot_time = 1
dt = 1
Time = []
surf = [[] for i=1:200]
VarList = []
for n in 1:25
    append!(Time,tot_time)
    randsurf = rand(1:200,dt)
    for i in randsurf
        append!(surf[i], 1)
    end
    SurfInTime = []
    for i in surf
        append!(SurfInTime, length(i))
    end
    append!(VarList,std(SurfInTime))
    tot_time += dt
    dt *= 2
end

A = [hcat(log.(Time)) reshape(ones(25), 25, 1)]
b = reshape(log.(VarList), 25, 1)

line = (A \ b)
x = 0:17
y = x .* line[1] .+ line[2]

theme(:dark)
gr()

scatter(log.(Time),log.(VarList),
    xlabel= "Log Time",
    ylabel= "Log W",
    title= "Log-Log plot of W-Time",
    legend = nothing)
plot!(x,y)
savefig("C:\\Users\\Yaghoub\\Desktop\\Deposition\\Random-Ballistic-Deposition\\log-log.png")
