using Plots, LaTeXStrings, Statistics

function Deposition(;len, tot_time, time_steps)
    Time = exp.(0:tot_time/(time_steps-1):tot_time)
    surf = [0 for i=1:len+2]
    VarList = [0.0 for i=1:time_steps]
    for n in 1:time_steps
        randsurf = rand(2:len+1,floor(Int,Time[n]*50 + exp(tot_time)/2))
        for i in randsurf
            if i == 2 && surf[i] >= surf[i-1] - 2
                surf[i-1] += 1
            elseif i == len+1 && surf[i] >= surf[i+1] - 2
                surf[i+1] += 1
            end
            lens = Dict(surf[i-1]=>i-1,
                surf[i]=>i,
                surf[i+1]=>i+1,
                )
            minlen = min(surf[i-1],surf[i],surf[i+1])
            surf[lens[minlen]] += 1
        end
        VarList[n] = std(surf)
    end
    return Time, VarList
end

function Linear_fit(;tot_time, time_steps)
    A = [hcat(log.(Time[1:time_steps])) reshape(ones(time_steps), time_steps, 1)]
    b = reshape(log.(VarList[1:time_steps]), time_steps, 1)
    line = (A \ b)
    x = 0:tot_time
    y = x .* line[1] .+ line[2]
    return x, y, line
end

Parameters = Dict(
                :len => 200,
                :tot_time => 10,
                :time_steps => 100
                    )

Time, VarList = Deposition(;Parameters...)
Paraline = Dict(
                :tot_time => 5,
                :time_steps => 30
                    )
X, Y, Line = Linear_fit(;Paraline...)

theme(:dark)
gr()

scatter(log.(Time),log.(VarList),
    xlabel= L"Log\ Time",
    ylabel= L"Log\ W_{(t)}",
    title= L"Log-Log\ Plot\ of\ ~W_{(t)}-Time~",
    label = L"Data\ point")
plot!(X,Y,label = L"y = %$(round(Line[1],digits= 2))x + %$(round(Line[2],digits= 2))")
savefig("C:\\Users\\Yaghoub\\Documents\\GitHub\\Ballistic-Deposition\\Deposition\\Ballistic-Deposition-with-Relaxation\\Fig\\log-log.png")
