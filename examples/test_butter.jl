using DiscreteFilters, ControlPlots, DSP, ControlSystemsBase, Printf, LaTeXStrings
include("plotting.jl")

# Define the cut-off frequency in Hz
cut_off_freq = 2.0

# Define the sampling time in seconds
dt = 0.05
sim_time = 4.0
N = Int(sim_time / dt)

# Design the filter
butter = create_filter(cut_off_freq; order=4, dt)

# Create an array of measurements
measurements = zeros(N)
for i in Int(N/2):N
    measurements[i] = 1.0
end

buffer = zeros(N)
results = zeros(N)
for i in 1:N
    results[i] = apply_filter(butter, measurements[i], buffer, i)
end

# Plot the results
plot((1:N)*dt, [measurements, results]; xlabel="Time (s)", ylabel="Amplitude", 
     fig="Forth order Butterworth Filter")

# Plot the frequency response
bo = tf(butter, dt)
bode_plot(bo; hz=true, from=0.5, to=1.5, title="4th order Butterworth Filter")