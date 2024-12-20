using DiscreteFilters, ControlPlots, DSP, ControlSystemsBase, Printf, LaTeXStrings
include("plotting.jl")

# Define the cut-off frequency in Hz
cut_off_freq = 2.0

# Define the sampling and simulation time in seconds
dt = 0.05
sim_time = 4.0
N = Int(sim_time / dt)

# Design the filter
butter = create_filter(cut_off_freq; order=4, dt)

# Create an array of measurements (step signal)
measurements = zeros(N)
for i in Int(N/2):N
    measurements[i] = 1.0
end

# apply the filter
results = zeros(N)
tfilter = DF2TFilter(butter)
for i in 1:N
    results[i] = apply_filter(tfilter, measurements[i], i)
end
@time apply_filter(tfilter, measurements[N], N)

# Plot the step response
p = plot((1:N)*dt, [measurements, results]; xlabel="Time (s)", ylabel="Amplitude", 
         labels=["Input" "Output"], fig="Forth order Butterworth Filter")
display(p)

# Plot the frequency response
bo = tf(butter, dt)
bode_plot(bo; hz=true, from=0.5, to=1.5, title="4th order Butterworth Filter")