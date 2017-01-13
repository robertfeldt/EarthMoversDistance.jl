# Change the double **matrix declarations and access in the C code to use a flat
# column-major float array.

# In function emd:
#  "double **cost" into "double *cost"
#  "cost[var->row][var->col]" => "cost[(var->row) + n_x * (var->col)]"
#  "cost[i][j]" => "cost[i + n_x * j]"
#  "cost[basis[i]->row][basis[i]->col]" => "cost[(basis[i]->row) + n_x * (basis[i]->col)]"
# and similar for double **flows...

# In function initialize_flow:
#  "double **cost" into "double *cost"

function translate_c_file(srcfile, destfile)
    str = open(srcfile, "r") do fh
        readstring(fh)
    end
    str = replace(str, "#include <emd.h>",                   "#include <emd_translated.h>")

    str = replace(str, "double **cost",                      "double *cost")

    str = replace(str, "cost[var->row][var->col]",           "cost[(var->row) + n_x * (var->col)]")
    str = replace(str, "cost[i][j]",                         "cost[i + n_x * j]")
    str = replace(str, "cost[basis[i]->row][basis[i]->col]", "cost[(basis[i]->row) + n_x * (basis[i]->col)]")

    str = replace(str, "double **flows",                      "double *flows")
    str = replace(str, "memset(flows[i], 0, n_y*sizeof(double));", "for(j = 0; j < n_y; j++) {flows[i + n_x * j]=0.0;};")
    str = replace(str, "flows[basis[i]->row][basis[i]->col]", "flows[(basis[i]->row) + n_x * (basis[i]->col)]")

    open(destfile, "w") do fh
        print(fh, str)
    end

    print_with_color(:green, "Translated double matrix references in file $(srcfile) and saved in $(destfile)\n")
end

translate_c_file(ARGS[1], ARGS[2])