using BinDeps
using Compat

vers = "2.0" # Use version number in setup.py file of pyEMD: https://raw.githubusercontent.com/garydoranjr/pyemd/master/setup.py

tagfile = "installed_vers"
target = "libemd.$(Libdl.dlext)"
srcdir = joinpath(dirname(@__FILE__()), "c_src")

if !isfile(target) || !isfile(tagfile) || readchomp(tagfile) != "$vers $(Sys.WORD_SIZE)"
    cd(srcdir) do
        println("Compiling libemd...")
        run(`make -f make.emd LIB=../$target`)
        run(`make -f make.emd clean`)
    end
    open(tagfile, "w") do f
        println(f, "$vers $(Sys.WORD_SIZE)")
    end
end