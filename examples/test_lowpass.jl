using DiscreteFilters, ControlPlots

# Define the cut-off frequency in Hz
cut_off_freq = 0.5

# Define the sampling time in seconds
dt = 0.1
sim_time = 10.0
N = Int(sim_time / dt)

# Create an array of measurements
measurements = zeros(N)
for i in Int(N/2):N
    measurements[i] = 1.0
end

results = zeros(N)

# Apply the EMA filter
for i in 1:N
    results[i] = ema_filter(measurements[i], cut_off_freq, dt)
end

# Plot the results
plot(collect(1:N)*dt, [measurements, results]; xlabel="Time (s)", ylabel="Amplitude", 
     fig="Exponential Moving Average Filter")