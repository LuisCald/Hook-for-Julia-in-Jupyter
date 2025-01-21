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