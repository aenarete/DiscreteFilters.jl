using DiscreteFilters, ControlPlots

# Define the cut-off frequency in Hz
cut_off_freq = 2.0

# Define the sampling time in seconds
dt = 0.05
sim_time = 4.0
N = Int(sim_time / dt)

# Design the filter
butter = create_filter(cut_off_freq; order=4, dt)
cheby1 = create_filter(cut_off_freq; order=4, type=:Cheby1, dt)

# Create an array of measurements
measurements = zeros(N)
for i in Int(N/2):N
    measurements[i] = 1.0
end

results = zeros(N)

# Apply the EMA filter
last_measurement::Float64 = 0.0
for i in 1:N
    global last_measurement
    results[i] = ema_filter(measurements[i], last_measurement, cut_off_freq, dt)
    last_measurement = results[i]
end

# Apply the Butterworth filter
buffer = zeros(N)
results_delay = zeros(N)
for i in 1:N
    results_delay[i] = apply_delay(measurements[i], buffer, i; delay=5)
end


# Plot the results
plot((1:N)*dt, [measurements, results, results_delay]; xlabel="Time (s)", ylabel="Amplitude", 
     fig="Delay of 5 samples")