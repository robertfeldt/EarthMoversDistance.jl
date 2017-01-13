__precompile__()

module EarthMoversDistance

export emd

using Compat
import Compat.String

const libemd = joinpath(dirname(@__FILE__), "..", "deps", "libemd")

function __init__()
    # If any init or destroy functions need to be called for the lib. 
    # In this case not, since emd is a "pure" function (no side effects).
    #ccall((:emd_init,libemd), Void, ())
    #atexit() do
    #    ccall((:emd_destroy,libemd), Void, ())
    #end
end

# low-level functions:
# double emd(int n_x, double *weight_x,
#           int n_y, double *weight_y,
#           double *cost, double *flows);
libemd_emd(n_x, weight_x, n_y, weight_y, cost, flows) =
    ccall((:emd,libemd), Cdouble,
          (Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          n_x, weight_x, n_y, weight_y, cost, flows)

libemd_emd2(n_x, weight_x, n_y, weight_y, cost) =
    ccall((:emd2,libemd), Cdouble,
          (Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Ptr{Cdouble}),
          n_x, weight_x, n_y, weight_y, cost)

# API
function emd!(Xweight::Vector{Float64}, Yweight::Vector{Float64}, cost::Matrix{Float64}, 
    flows::Union{Void, Matrix{Float64}} = nothing)

    n_x = length(Xweight)
    n_y = length(Yweight)

    @assert n_x > 0
    @assert n_y > 0

    @assert n_x == size(cost, 1)
    @assert n_y == size(cost, 2)

    if flows != nothing
        @assert n_y == size(flows, 2)
        @assert n_x == size(flows, 1)
        libemd_emd(n_x, pointer(Xweight), n_y, pointer(Yweight), pointer(cost), pointer(flows))
    else
        libemd_emd(n_x, pointer(Xweight), n_y, pointer(Yweight), pointer(cost), C_NULL)
    end
end

function emd(Xweight::Vector{Float64}, Yweight::Vector{Float64}, cost::Union{Void, Matrix{Float64}} = nothing)
    if cost == nothing
        cost = ones(Float64, length(Xweight), length(Yweight))
    end
    emd!(Xweight, Yweight, cost)
end

function emd_flows(Xweight::Vector{Float64}, Yweight::Vector{Float64}, cost::Union{Void, Matrix{Float64}} = nothing)
    if cost == nothing
        cost = ones(Float64, length(Xweight), length(Yweight))
    end
    flows = zeros(cost)
    distance = emd!(Xweight, Yweight, cost, flows)
    return distance, flows
end

end