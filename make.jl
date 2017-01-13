PackageName = "EarthMoversDistance"
File = last(split(@__FILE__(), "/"))
cmd = "$File"
juliaflags = "--color=yes"

doc = """Convenience command for updating and testing the $(PackageName).jl package.

Usage:
  $cmd update emd
  $cmd translatec
  $cmd build
  $cmd rebuild
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

function update_emd()
    cd(joinpath("deps", "c_src")) do
        isfile("emd.c") && rm("emd.c")
        isfile("emd.h") && rm("emd.h")
        run(`wget https://raw.githubusercontent.com/garydoranjr/pyemd/master/c_emd/emd.c`)
        run(`wget https://raw.githubusercontent.com/garydoranjr/pyemd/master/c_emd/emd.h`)
    end
    print_with_color(:green, "Downloaded latest emd c source files from pyEMD project on github.\n")
end

if arguments["update"] && arguments["emd"]
    update_emd()
    exit(0)
end

function translate_c()
  cd("deps") do
    run(`julia --color=yes translate_c.jl c_src/emd.c c_src/emd_translated.c`)
    run(`julia --color=yes translate_c.jl c_src/emd.h c_src/emd_translated.h`)
  end
end

if arguments["translatec"]
    translate_c()
    exit(0)  
end

function build()
  cd("deps") do
    run(`julia $(juliaflags) build.jl`)
  end
end

function clean()
  cd("deps") do
    run(`rm -f installed_vers libemd.dylib libemd.so`)
  end
end

if arguments["rebuild"]
  clean()
  build()
  exit(0)
end

if arguments["build"]
  build()
  exit(0)
end

if arguments["clean"]
  clean()
  exit(0)
end

if arguments["test"]
    if arguments["latest"]
        print_with_color(:green, "Running latest changed test file.\n")
        run(`julia --color=yes -L src/$(PackageName).jl $(latest_changed_testfile())`)
    else
        print_with_color(:green, "Running all tests.\n")
        run(`julia --color=yes -L src/$(PackageName).jl test/runtests.jl`)
    end
end
