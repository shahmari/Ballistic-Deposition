using Plots, LaTeXStrings, Statistics

function Deposition(;len, tot_time, time_steps)
    Time = exp.(0:tot_time/(time_steps):tot_time)
    surf = [0 for i=1:len]
    VarList = [0.0 for i=1:time_steps]
    for n in 2:time_steps+1
        randsurf = rand(1:len,floor(Int,Time[n]-Time[n-1]))
        for i in randsurf
            index = FindLeast(surf, i, len)
            surf[index] += 1
        end
        VarList[n-1] = std(surf)
    end
    return Time, VarList
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

function FindLeast(surface, index_,L_surf)
    i1 , i2 = sides(index_, L_surf)
    lens = Dict(surface[i1]=>i1,
        surface[index_]=>index_,
        surface[i2]=>i2)
    minlen = min(surface[i1],surface[index_],surface[i2])
    return lens[minlen]
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
        standev = std(Line[1].*Time .+ Line[2] .- VarList)
        if absl > 1 && standev > 2 && retline == [0.0 0.0]
            retline = Line
        end
        if absl > 2 && standev > 3
            return retline, i
        end
    end
end

theme(:dark)
gr()

#=
Parameters = Dict(
                :len => 200,
                :tot_time => 8,
                :time_steps => 100)
Time, VarList = Deposition(;Parameters...)

scatter(log.(Time),log.(VarList),
    xlabel= L"Log\ Time",
    ylabel= L"Log\ W_{(t)}",
    title= L"Log-Log\ Plot\ of\ ~W_{(t)}-Time~",
    label = L"Data\ point")


Line, last_point = FindLine(Parameters[:time_steps], Time, VarList)
X = 0:log(Time[last_point])
Y = X .* Line[1] .+ Line[2]
plot!(X,Y,label = L"y = %$(round(Line[1],digits= 2))x + %$(round(Line[2],digits= 2))")

savefig("C:\\Users\\Yaghoub\\Documents\\GitHub\\Ballistic-Deposition\\Deposition\\Ballistic-Deposition-with-Relaxation\\Fig\\log-log.png")
=#
iternum = 1000
Parameters = Dict(:len => 300,
                    :tot_time => 12,
                        :time_steps => 100)
allVar = [ [0.0 for i in 1:Parameters[:time_steps]] for j = 1:iternum]
meanVar = [0.0 for i in 1:Parameters[:time_steps]]
vars = [0.0 for i in 1:Parameters[:time_steps]]
for i in 1:iternum
    Time, VarList = Deposition(;Parameters...)
    allVar[i] = VarList
    meanVar += VarList
    print("\r$i")
end
meanVar /= iternum
for i in 1:Parameters[:time_steps]
    vars[i] = std(log.(hcat(allVar...))[i,:])
end

Time = hcat(0:Parameters[:tot_time]/(Parameters[:time_steps]-1):Parameters[:tot_time])
scatter(Time, log.(meanVar),
    xlabel= L"Log\ Time",
    ylabel= L"Log\ W_{(t)}",
    title= L"Log-Log\ Plot\ ~W_{(t)}-Time~\ (L = 300)",
    label = L"Data\ point",
    yerror = vars,
    legend = nothing)
#savefig("C:\\Users\\Yaghoub\\Documents\\GitHub\\Ballistic-Deposition\\Deposition\\Ballistic-Deposition-with-Relaxation\\Fig\\W-t(L=200).png")

#=
Time = exp.(0:Parameters[:tot_time]/(Parameters[:time_steps]-1):Parameters[:tot_time])
Line, last_point = FindLine(Parameters[:time_steps], Time, VarList)
X = 0:log(Time[last_point])
Y = X .* Line[1] .+ Line[2] =#

#plot!(X,Y,label = L"y = %$(round(Line[1],digits= 2))x + %$(round(Line[2],digits= 2))")
