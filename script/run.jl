using FSM
using CSV
using DataFrames
using ProgressMeter

data_force = CSV.File("data/met_CdP_0506.csv") |> DataFrame

input = Input{Float64}(
    data_force.year,
    data_force.month,
    data_force.day,
    data_force.hour,
    data_force.SW,
    data_force.LW,
    data_force.Sf,
    data_force.Rf,
    data_force.Ta,
    data_force.RH,
    data_force.Ua,
    data_force.Ps,
    )

function run_many(n)

    snowdepth = similar(input.Ta)
    SWE = similar(input.Ta)
    Tsurf = similar(input.Ta)

    @showprogress 1 "Computing..." for i in 1:n
        ebm = EBM{Float64}(
            am=1,
            cm=1,
            dm=1,
            em=1,
            hm=1,
        )

        cn = Constants{Float64}()

        snowdepth .= 0
        SWE .= 0
        Tsurf .= 0

        run!(ebm, cn, snowdepth, SWE, Tsurf, input)

    end

end

@time run_many(100000)
