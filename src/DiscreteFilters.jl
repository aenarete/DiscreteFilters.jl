module DiscreteFilters

using DSP

export ema_filter, create_filter, apply_filter

"""
    ema_filter(measurement, last_measurement, cut_off_freq, dt)

An exponential moving average (EMA), also known as an exponentially weighted moving average (EWMA),
is a type of infinite impulse response filter that applies weighting factors which decrease exponentially.
The weighting for each older datum decreases exponentially, never reaching zero.

# Arguments
- `measurement`: The measurement value
- `last_measurement`: The last measurement value
- `cut_off_freq`: The cut off frequency in Hz
- `dt`: The sampling time in seconds

# Returns
- The filtered value
"""
function ema_filter(measurement, last_measurement, cut_off_freq, dt)
    if cut_off_freq > 0.0
        alpha = dt / (dt + one(measurement) / (2π * cut_off_freq))
        filtered_value = alpha * measurement + (one(measurement) - alpha) * last_measurement
    else
        filtered_value = measurement
    end
    return filtered_value
end


"""
    create_filter(cut_off_freq; order=4, dt)

Design a Butterworth filter with the given cut-off frequency.

# Arguments
- `cut_off_freq`: The cut-off frequency in Hz
- `order`: The order of the filter, optionally, default: 4
- `dt`: The sampling time in seconds
"""
function create_filter(cut_off_freq; order=4, dt)
    Filters.digitalfilter(Filters.Lowpass(cut_off_freq; fs=1/dt), Filters.Butterworth(order))
end

"""
    apply_filter(butter, measurement, buffer, index)

Apply the filter to the measurement.

# Arguments
- `butter`: The filter, created with `create_filter`
- `measurement`: The measurement value
- `buffer`: The buffer to store the measurements
- `index`: The index of the measurement
"""
function apply_filter(butter, measurement, buffer, index)
    buffer[index] = measurement
    res = filt(butter, buffer[1:index])
    return res[index]
end

end
