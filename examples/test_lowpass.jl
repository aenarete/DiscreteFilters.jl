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
results_butter = zeros(N)
for i in 1:N
    results_butter[i] = apply_filter(butter, measurements[i], buffer, i)
end

# Apply the Cheby1 filter
buffer = zeros(N)
results_cheby1 = zeros(N)
for i in 1:N
    results_cheby1[i] = apply_filter(cheby1, measurements[i], buffer, i)
end

# Plot the results
plot((1:N)*dt, [measurements, results, results_butter, results_cheby1]; xlabel="Time (s)", ylabel="Amplitude", 
     fig="Exponential Moving Average and Butterworth Filters")