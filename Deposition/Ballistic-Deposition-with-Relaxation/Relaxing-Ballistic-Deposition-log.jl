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

function Linear_fit(;Time, VarList, time_steps)
    A = [hcat(log.(Time[1:time_steps])) reshape(ones(time_steps), time_steps, 1)]
    b = reshape(log.(VarList[1:time_steps]), time_steps, 1)
    line = (A \ b)
    return line
end

function FindLine(tot_steps, Time, VarList)
    retline = [0.0 0.0]
    for i in 5:tot_steps
        Paraline = Dict(
                        :Time => Time,
                        :VarList => VarList,
                        :time_steps => i
                            )
        Line = Linear_fit(;Paraline...)
        absl = abs(Line[1]*Time[i] + Line[2] - VarList[i])
        standev = std(Line[1].*Time[2:i] .+ Line[2] .- VarList[2:i])
        if absl > 1.2 && standev > 1.5 && retline == [0.0 0.0]
            retline = Line
        end
        if absl > 3 && standev > 2.7
            return retline, i
        end
    end
end

Parameters = Dict(
                :len => 300,
                :tot_time => 12,
                :time_steps => 100)
Time, VarList = Deposition(;Parameters...)

#theme(:dark)
#gr()

scatter(log.(Time),log.(VarList),
    xlabel= L"Log\ Time",
    ylabel= L"Log\ W_{(t)}",
    title= L"Log-Log\ Plot\ of\ ~W_{(t)}-Time~",
    label = L"Data\ point")


Line, last_point = FindLine(Parameters[:time_steps], Time, VarList)
X = 0:log(Time[last_point])
Y = X .* Line[1] .+ Line[2]
plot!(X,Y,label = L"y = %$(round(Line[1],digits= 2))x + %$(round(Line[2],digits= 2))")

#savefig("C:\\Users\\Yaghoub\\Documents\\GitHub\\Ballistic-Deposition\\Deposition\\Ballistic-Deposition-with-Relaxation\\Fig\\log-log.png")
