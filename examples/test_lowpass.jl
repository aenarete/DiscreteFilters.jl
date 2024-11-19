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

# Plot the results
plot((1:N)*dt, [measurements, results, results_butter]; xlabel="Time (s)", ylabel="Amplitude", 
     fig="Exponential Moving Average and Butterworth Filters")