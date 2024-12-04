using DiscreteFilters, ControlPlots, DSP, ControlSystemsBase, Printf, LaTeXStrings
include("plotting.jl")

function create_filter2(cut_off_freq; order=4, type=:Butter, dt)
    if type == :Butter
        return (Filters.digitalfilter(Filters.Lowpass(cut_off_freq; fs=1/dt), Filters.Butterworth(order)))
    elseif type == :Cheby1
        return (Filters.digitalfilter(Filters.Lowpass(cut_off_freq; fs=1/dt), Filters.Chebyshev1(order, 0.01)))
    end
end
function apply_filter2(butterF, measurement, index)
    results = zeros(1)
    measurements = ones(1) * measurement
    @views filt!(results[1:1], butterF, measurements)
    return results[1]
end

# Define the cut-off frequency in Hz
cut_off_freq = 2.0

# Define the sampling and simulation time in seconds
dt = 0.05
sim_time = 4.0
N = Int(sim_time / dt)

# Design the filter
butter = create_filter2(cut_off_freq; order=4, dt)

# Create an array of measurements (step signal)
measurements = zeros(N)
for i in Int(N/2):N
    measurements[i] = 1.0
end

# apply the filter
results = zeros(N)
tfilter = DSP.Filters.DF2TFilter(butter)
for i in 1:N
    results[i] = apply_filter2(tfilter, measurements[i], i)
end
@time apply_filter2(tfilter, measurements[N], N)

# Plot the step response
p = plot((1:N)*dt, [measurements, results]; xlabel="Time (s)", ylabel="Amplitude", 
         labels=["Input" "Output"], fig="Forth order Butterworth Filter")
display(p)

# Plot the frequency response
bo = tf(butter, dt)
bode_plot(bo; hz=true, from=0.5, to=1.5, title="4th order Butterworth Filter")