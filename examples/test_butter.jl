using DiscreteFilters, ControlPlots, DSP

# Define the cut-off frequency in Hz
cut_off_freq = 2.0

# Define the sampling time in seconds
dt = 0.05
fs = 1/dt
sim_time = 4.0
N = Int(sim_time / dt)

# Design the filter
butter = Filters.digitalfilter(Filters.Lowpass(cut_off_freq; fs), Filters.Butterworth(4))

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