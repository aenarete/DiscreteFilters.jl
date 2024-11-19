using DiscreteFilters, ControlPlots, DSP

# Define the cut-off frequency in Hz
cut_off_freq = 2.0
Wn = cut_off_freq

# Define the sampling time in seconds
dt = 0.05
fs = 1/dt
sim_time = 4.0
N = Int(sim_time / dt)

# Design the filter
butter = Filters.digitalfilter(Filters.Lowpass(Wn; fs), Filters.Butterworth(2))

# Create an array of measurements
measurements = zeros(N)
for i in Int(N/2):N
    measurements[i] = 1.0
end

results = filt(butter, measurements)

# Plot the results
plot((1:N)*dt, [measurements, results]; xlabel="Time (s)", ylabel="Amplitude", 
     fig="Forth order Butterworth Filter")