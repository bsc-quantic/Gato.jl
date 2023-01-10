using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

push!(LOAD_PATH, "$(@__DIR__)/..")

using Weave
filename = normpath(@__DIR__, "pauli-gates.jmd")

ENV["GKSwstype"] = "nul"
weave(filename, informat="markdown", doctype="md2html")