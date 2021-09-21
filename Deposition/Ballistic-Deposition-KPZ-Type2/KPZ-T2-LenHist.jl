using Plots, LaTeXStrings, Statistics

function Deposition(; len, tot_time, dep_rate, color_step)
    surface = InitialSurf(len)
    AllLens = []
    for n in 0:tot_time
        randsurf = rand(1:len, dep_rate)
        for i in randsurf
            surface = check_and_depose(surface, i, len, (n%color_step) + 1)
        end
        append!(AllLens, Check_Dlen(surface))
    end
    return AllLens
end

function Check_Dlen(surf)
    Dlen = []
    for i in surf
        len = 0
        for num in i
            if num != 0
                len += 1
            end
        end
        append!(Dlen, len)
    end
    return max(Dlen...)
end

function check_and_depose(surf, index, len, addval) #checking down and sides and first layer
    i1 , i2 = sides(index, len)
    if surf[end][index] != 0
        newsurf = [0 for j = 1:len]
        newsurf[index] = addval
        push!(surf, newsurf)
    end
    for num in 0:length(surf) -1
        if surf[end - num][index] == 0 && (surf[end - num][i1] != 0 || surf[end - num][i2] != 0)
            surf[end - num][index] = addval
            break
        elseif length(surf) > num + 1 && surf[end - 1 - num][index] != 0
            surf[end - num][index] = addval
            break
        end
    end
    return surf
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

Parameters = Dict(:len => 300,
                    :tot_time => 50,
                        :dep_rate => 2000,
                            :color_step => 100)


iternum = 200
allVal = [ [0.0 for i in 0:Parameters[:tot_time]] for j = 1:iternum]
meanVal = [0.0 for i in 0:Parameters[:tot_time]]
vars = [0.0 for i in 0:Parameters[:tot_time]]
for i in 1:iternum
    VarList = Deposition(;Parameters...)
    allVal[i] = VarList
    meanVal += VarList
    print("\r$i")
end
meanVal /= iternum
for i in 1:Parameters[:tot_time] + 1
    vars[i] = std(hcat(allVal...)[i,:])
end

theme(:dark)
gr()
# plot(meanVal,yerror = vars)
scatter(0:Parameters[:tot_time], meanVal,
    xlabel= L"Time",
    ylabel= L"Transverse\ width",
    title= L"Transverse\ width-Time~\ (L = %$(Parameters[:len]))",
    label = L"Data\ point",
    yerror = vars,
    legend = 150)

savefig("C:\\Users\\Yaghoub\\Documents\\GitHub\\Ballistic-Deposition\\Deposition\\Ballistic-Deposition-KPZ-Type2\\Fig\\histplot.png")
