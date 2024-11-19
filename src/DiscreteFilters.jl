module DiscreteFilters

export ema_filter

"""
    ema_filter(measurement, filtered_value, cut_off_freq, dt)

An exponential moving average (EMA), also known as an exponentially weighted moving average (EWMA),
is a type of infinite impulse response filter that applies weighting factors which decrease exponentially.
The weighting for each older datum decreases exponentially, never reaching zero.

# Arguments
- `measurement`: The measurement value
- `cut_off_freq`: The cut off frequency in Hz
- `dt`: The sampling time (h) in seconds

# Returns
- The filtered value
"""
function ema_filter(measurement, cut_off_freq, dt)
    filtered_value = zero(measurement)
    if cut_off_freq > 0.0
        alpha = dt / (dt + one(measurement) / (2π * cut_off_freq))
        filtered_value = alpha * measurement + (one(measurement) - alpha) * filtered_value
    else
        filtered_value = measurement
    end
    return filtered_value
end

end
