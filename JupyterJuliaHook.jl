using JSON
using JuliaFormatter

function format_notebook(file)
    local notebook
    try
        # Parse the notebook JSON
        notebook = JSON.parsefile(file)
    catch e
        println("Error parsing JSON file: $file")
        println("Reason: ", e)
        return
    end

    for cell in notebook["cells"]
        if cell["cell_type"] == "code" 
            # Format the code in the cell
            cell["source"] = format_text(join(cell["source"]), BlueStyle())
            cell["source"] = convert.(String, cell["source"])
            for (i,j) in enumerate(cell["source"])
                cell["source"][i] = j * "\n"
            end
        end
    end

    # Save the formatted notebook
    open(file, "w") do io
        JSON.print(io, notebook)
    end
    println("Formatted notebook: $file")
end

# # Apply formatting to a specific notebook
# format_notebook("/Users/lc/Desktop/Desktop_folder/BASEforHANK/BASEtoolbox.jl/examples/ss_comparative_statics/steady_state_comparative_statics_copy.ipynb")

# Run the formatter on the provided file
if length(ARGS) > 0
    format_notebook(ARGS[1])
else
    println("No file provided to format.")
end
notebook = JSON.parsefile("/Users/lc/Desktop/Desktop_folder/BASEforHANK/BASEtoolbox.jl/examples/ss_comparative_statics/steady_state_comparative_statics_copy.ipynb")

b = format_text(a, BlueStyle())
open("/Users/lc/Desktop/Desktop_folder/BASEforHANK/BASEtoolbox.jl/examples/ss_comparative_statics/test.ipynb", "w") do io
    JSON.print(io, notebook)
end
c = replace(b, r"\n" => r"\n ")
c = split(c, '\n')
a = join([
    "\"\"\"\n",
    "Mainboard for running comparative statics of steady-state block of the BASEforHANK package.\n",
    "\"\"\"\n",
    "\n",
    "using Pkg \n",
    "\n",
    "## ------------------------------------------------------------------------------------------\n",
    "## Header: set up paths, pre-process user inputs, load module\n",
    "## ------------------------------------------------------------------------------------------\n",
    "\n",
    "root_dir = replace(Base.current_project(), \"Project.toml\" => \"\");\n",
    "cd(root_dir);\n",
    "\n",
    "# set up paths for the project\n",
    "paths = Dict(\n",
    "    \"root\" => root_dir,\n",
    "    \"src\" => joinpath(root_dir, \"src\"),\n",
    "    \"bld\" => joinpath(root_dir, \"bld\"),\n",
    "    \"src_example\" => joinpath(root_dir, \"examples/ss_comparative_statics\"), # Changed from @__DIR__ to ss example \n",
    "    \"bld_example\" => joinpath(root_dir, \"bld/ss_comparative_statics\"), #replace(@__DIR__, \"examples\" => \"bld\") # Changed to ss example \n",
    ");\n",
    "\n",
    "# create bld directory for the current example\n",
    "mkpath(paths[\"bld_example\"]);\n",
    "Pkg.activate(\".\")\n",
    "Pkg.instantiate()\n",
    "\n",
    "# pre-process user inputs for model setup\n",
    "include(paths[\"src\"] * \"/Preprocessor/PreprocessInputs.jl\");\n",
    "include(paths[\"src\"] * \"/BASEforHANK.jl\");\n",
    "using .BASEforHANK;\n",
    "using BenchmarkTools;\n",
    "using Plots\n",
    "using LaTeXStrings\n",
    "\n",
    "# set BLAS threads to the number of Julia threads, prevents BLAS from grabbing all threads on a machine\n",
    "BASEforHANK.LinearAlgebra.BLAS.set_num_threads(Threads.nthreads());\n",
    "\n",
    "## ------------------------------------------------------------------------------------------\n",
    "## Initialize: set up model parameters, priors, and estimation settings\n",
    "## ------------------------------------------------------------------------------------------\n",
    "\n",
    "# model parameters and priors\n",
    "# model parameters\n",
    "m_par = ModelParameters();\n",
    "e_set = BASEforHANK.e_set;\n",
    "\n",
    "# set some paths\n",
    "@set! e_set.save_mode_file = paths[\"bld_example\"] * \"/HANK_mode.jld2\";\n",
    "@set! e_set.mode_start_file = paths[\"src_example\"] * \"/Data/parameter_example.jld2\";\n",
    "\n",
    "# fix seed for random number generation\n",
    "BASEforHANK.Random.seed!(e_set.seed);"
   ])