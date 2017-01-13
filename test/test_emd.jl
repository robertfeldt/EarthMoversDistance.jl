using EarthMoversDistance: emd!, libemd_emd, emd, emd_flows

W1 = [0.4, 0.2, 0.2, 0.1, 0.1]
W2 = [0.6, 0.2, 0.2]
Cost1 = ones(Float64, 5, 3)

@testset "Calling the C function emd directly" begin
    flows = zeros(Float64, 5, 3)
    distance = libemd_emd(length(W1), W1, length(W2), W2, Cost1, flows)
    @test distance == 1.0
    @test isapprox(flows[1, 1], 0.4)
    @test isapprox(flows[2, 1], 0.2)
    @test isapprox(flows[3, 2], 0.2)
    @test isapprox(flows[4, 3], 0.1)
    @test isapprox(flows[5, 3], 0.1)
    @test Cost1 == ones(Float64, 5, 3)
end

@testset "emd" begin
    distance = emd(W1, W2, Cost1)
    @test distance == 1.0
    @test Cost1 == ones(Float64, 5, 3)
end

@testset "emd_flows" begin
    distance, flows = emd_flows(W1, W2, Cost1)
    @test distance == 1.0
    @test isapprox(flows[1, 1], 0.4)
    @test isapprox(flows[2, 1], 0.2)
    @test isapprox(flows[3, 2], 0.2)
    @test isapprox(flows[4, 3], 0.1)
    @test isapprox(flows[5, 3], 0.1)
    @test Cost1 == ones(Float64, 5, 3)
end
