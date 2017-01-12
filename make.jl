PackageName = "EarthMoversDistance"
File = last(split(@__FILE__(), "/"))
cmd = "$File"

doc = """Convenience command for updating and testing the $(PackageName).jl package.

Usage:
  $cmd update emd
  $cmd test
  $cmd test latest
  $cmd clean
  $cmd -h | --help
  $cmd --version

Options:
  -h --help     Show this screen.
  --version     Show version.

"""
using DocOpt
arguments = docopt(doc, version=v"0.0.1")

if arguments["update"] && arguments["emd"]
    cd(joinpath("deps", "c_src")) do
        isfile("emd.c") && rm("emd.c")
        isfile("emd.h") && rm("emd.h")
        run(`wget https://raw.githubusercontent.com/garydoranjr/pyemd/master/c_emd/emd.c`)
        run(`wget https://raw.githubusercontent.com/garydoranjr/pyemd/master/c_emd/emd.h`)
    end
    print_with_color(:green, "Downloaded latest emd c source files from pyEMD project on github.\n")
    exit(0)
end

if arguments["clean"]
  cd("deps") do
    run(`rm -f installed_vers libemd.dylib libemd.so`)
  end
  exit(0)
end

if arguments["test"]
    if arguments["latest"]
        print_with_color(:green, "Running latest changed test file.\n")
        run(`julia -L src/$(PackageName).jl $(latest_changed_testfile()`)
    else
        print_with_color(:green, "Running all tests.\n")
        run(`julia -L src/$(PackageName).jl test/runtests.jl`)
    end
end
