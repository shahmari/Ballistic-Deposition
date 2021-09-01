using Plots, LaTeXStrings, Statistics

function Deposition(;len, tot_time, time_steps)
    Time = exp.(0:tot_time/(time_steps-1):tot_time)
    surf = [0 for i=1:len]
    VarList = [0.0 for i=1:time_steps]
    for n in 1:time_steps
        randsurf = rand(1:len,floor(Int,Time[n]*1000 + 1000))
        for i in randsurf
            surf[i] += 1
        end
        VarList[n] = std(surf)
    end
    return Time, VarList
end

function Linear_fit(;len, tot_time, time_steps)
    A = [hcat(log.(Time)) reshape(ones(time_steps), time_steps, 1)]
    b = reshape(log.(VarList), time_steps, 1)
    line = (A \ b)
    x = 0:tot_time
    y = x .* line[1] .+ line[2]
    return x, y, line
end

Parameters = Dict(
                :len => 200,
                :tot_time => 10,
                :time_steps => 20
                    )

Time, VarList = Deposition(;Parameters...)
X, Y, Line = Linear_fit(;Parameters...)

theme(:dark)
gr()

scatter(log.(Time),log.(VarList),
    xlabel= L"Log\ Time",
    ylabel= L"Log\ W_{(t)}",
    title= L"Log-Log\ Plot\ of\ ~W_{(t)}-Time~",
    label = L"Data\ point")
plot!(X,Y,label = L"y = %$(round(Line[1],digits= 2))x + %$(round(Line[2],digits= 2))")
savefig("C:\\Users\\Yaghoub\\Documents\\GitHub\\Ballistic-Deposition\\Deposition\\Random-Ballistic-Deposition\\Fig\\log-log.png")
