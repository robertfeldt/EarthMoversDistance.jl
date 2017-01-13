using EarthMoversDistance: emd!, libemd_emd

@testset "Calling the C function emd directly" begin
    w1 = [0.4, 0.2, 0.2, 0.1, 0.1]
    w2 = [0.6, 0.2, 0.2]
    cost = ones(Float64, 5, 3)
    flows = zeros(Float64, 5, 3)
    distance = libemd_emd(length(w1), w1, length(w2), w2, cost, flows)
    @test distance == 1.0
    @test isapprox(flows[1, 1], 0.4)
    @test isapprox(flows[2, 1], 0.2)
    @test isapprox(flows[3, 2], 0.2)
    @test isapprox(flows[4, 3], 0.1)
    @test isapprox(flows[5, 3], 0.1)
    @test cost == ones(Float64, 5, 3)
end
