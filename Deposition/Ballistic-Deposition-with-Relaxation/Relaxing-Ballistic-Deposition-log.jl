using Plots
using Statistics
Time = exp.(0:10/500:10)
surf = zeros(Int,202)
VarList = []
for n in 1:501
    randsurf = rand(2:201,Int(floor(Time[n] + 30000)))
    for i in randsurf
        if i == 2 && surf[i] >= surf[i-1] - 2
            surf[i-1] += 1
        elseif i == 201 && surf[i] >= surf[i+1] - 2
            surf[i+1] += 1
        end
        len = Dict(surf[i-1]=>i-1,
            surf[i]=>i,
            surf[i+1]=>i+1,
            )
        minlen = min(surf[i-1],surf[i],surf[i+1])
        surf[len[minlen]] += 1
    end
    append!(VarList,std(surf))
    print("\r",n)
end

theme(:dark)
gr()

#=
scatter(Time,VarList,
    xscale=:log,
    yscale=:log,
    xlabel= "Time",
    ylabel= "W",
    title= "Log plot of W-Time",
    legend = nothing)
savefig("C:\\Users\\Yaghoub\\Desktop\\Deposition\\Ballistic-Deposition-with-Relaxation\\log-scale-2.png")
=#

range_num = 40
A = [hcat(log.(Time[1:range_num])) reshape(ones(range_num), range_num, 1)]
b = reshape(log.(VarList[1:range_num]), range_num, 1)

line = (A \ b)
x = -0.1:0.01:1
y = x .* line[1] .+ line[2]

scatter(log.(Time),log.(VarList),
    xlabel= "Log Time",
    ylabel= "Log W",
    title= "Log-Log plot of W-Time",
    legend = nothing)
plot!(x,y)
savefig("C:\\Users\\Yaghoub\\Desktop\\Deposition\\Ballistic-Deposition-with-Relaxation\\log-log.png")
