using CSV, DataFrames, Plots

# Read CSV files
julia_pinv = Matrix(CSV.read("julia-pinv.csv", DataFrame, datarow=1))
julia_qr = Matrix(CSV.read("julia-qr.csv", DataFrame, datarow=1))
python_ls = Matrix(CSV.read("python-ls.csv", DataFrame, datarow=1))

# Plot
plot( julia_pinv[:, 1], julia_pinv[:, 2], seriestype = :scatter, color=:green,
      alpha=0.5, label="Julia/LinearAlgebra/OpenBlas: pinv")
plot!(julia_qr[:, 1], julia_qr[:, 2], seriestype = :scatter, color=:red,
      alpha=0.5, label="Julia/LinearAlgebra/OpenBlas: qr")
plot!(python_ls[:, 1], python_ls[:, 2], seriestype = :scatter, color=:blue,
      alpha=0.5, label="Python/NumPy/OpenBlas: lstsq")
plot!(xlabel="Size", ylabel="Time | s", legend=:topleft)
savefig("benchmark.png")


