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
            formatted_code = format_text(join(cell["source"]), BlueStyle())
            split_code = split(formatted_code, '\n')
            cell["source"] = convert.(String, split_code)
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
