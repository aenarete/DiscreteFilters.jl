module DiscreteFilters

using DSP

export ema_filter, create_filter, apply_filter, apply_delay

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
function create_filter(cut_off_freq; order=4, type=:Butter, dt)
    if type == :Butter
        return Filters.digitalfilter(Filters.Lowpass(cut_off_freq; fs=1/dt), Filters.Butterworth(order))
    elseif type == :Cheby1
        return Filters.digitalfilter(Filters.Lowpass(cut_off_freq; fs=1/dt), Filters.Chebyshev1(order, 0.01))
    end
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
"""
    apply_filter(tfilter::DF2TFilter, measurement, index)

Apply the filter to the measurement.

# Arguments
- `tfilter`: The filter, created with `create_filter` and converted to a DF2TFilter
- `measurement`: The measurement value
- `buffer`: The buffer to store the measurements
- `index`: The index of the measurement
"""
function apply_filter(tfilter::DF2TFilter, measurement, index)
    results = zeros(1)
    measurements = ones(1) * measurement
    @views filt!(results[1:1], tfilter, measurements)
    return results[1]
end

function apply_delay(measurement, buffer, index; delay=1)
    buffer[index] = measurement
    if index-delay < 1
        return measurement
    else
        return buffer[index-delay]
    end
end

end
