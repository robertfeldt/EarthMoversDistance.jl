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

@testset "python-emd example1" begin
    # This corresponds to the example in the file: https://github.com/pdinges/python-emd/blob/master/example1.py

    # features1 = [Feature(100, 40, 22), Feature(211, 20, 2),
    #             Feature(32, 190, 150), Feature(2, 100, 100)]
    # weights1  = [0.4, 0.3, 0.2, 0.1]
    features1 = [[100, 40, 22], [211, 20, 2], [32, 190, 150], [2, 100, 100]]
    weights1  = [0.4, 0.3, 0.2, 0.1]
    
    #features2 = [Feature(0, 0, 0), Feature(50, 100, 80), Feature(255, 255, 255)]
    #weights2  = [0.5, 0.3, 0.2]
    features2 = [[0, 0, 0], [50, 100, 80], [255, 255, 255]]
    weights2  = [0.5, 0.3, 0.2]

    # The costs are the euclidean distances between all pairs
    cost = zeros(Float64, length(features1), length(features2))
    for i in 1:length(features1)
        for j in 1:length(features2)
            cost[i, j] = sqrt(sum((features1[i] .- features2[j]).^2))
        end
    end

    distance = emd(weights1, weights2, cost)
    @show distance
    @test isapprox(distance, 160.542; atol = 1e-3)
end
