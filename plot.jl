using CSV, DataFrames, Plots, LaTeXStrings

# Read CSV files
julia_pinv = Matrix(CSV.read("julia-pinv.csv", DataFrame, datarow=1))
julia_qr = Matrix(CSV.read("julia-qr.csv", DataFrame, datarow=1))
python_ls = Matrix(CSV.read("python-ls.csv", DataFrame, datarow=1))
matlab_qr = Matrix(CSV.read("matlab-qr.csv", DataFrame, datarow=1))
matlab_backslash = Matrix(CSV.read("matlab-backslash.csv", DataFrame, datarow=1))

# Plot
plot( julia_pinv[:, 1], julia_pinv[:, 2], seriestype = :scatter, color=:green,
      alpha=0.5, label=L"Julia/LinearAlgebra/OpenBlas: pinv(A)*B")
plot!(julia_qr[:, 1], julia_qr[:, 2], seriestype = :scatter, color=:red,
      alpha=0.5, label=L"Julia/LinearAlgebra/OpenBlas: qr(A,Val(true)) \setminus B")
plot!(python_ls[:, 1], python_ls[:, 2], seriestype = :scatter, color=:blue,
      alpha=0.5, label=L"Python/SciPy/OpenBlas: linalg.lstsq(A,B)[0]")
plot!(matlab_qr[:, 1], matlab_qr[:, 2], seriestype = :scatter, color=:brown,
      alpha=0.5, label=L"Matlab/: [qq,rr]=qr(A);rr \setminus qq.'*B")
plot!(matlab_backslash[:, 1], matlab_backslash[:, 2], seriestype = :scatter, color=:orange,
      alpha=0.5, label=L"Matlab/: A \setminus B")
plot!(xlabel=L"Size", ylabel=L"Time | s",  yaxis=:log, dpi=300) #, legend=:topleft)
savefig("benchmark.png")

