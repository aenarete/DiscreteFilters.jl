##########################################################################################
#               The following plots are bode plots in the frequency domain               #
##########################################################################################

"""
    frequency_response(sys; from=-1, to=2)

Calculate the response of a linear system in the frequency domain.

Parameters:
- sys:  linear system
- from: exp10 of the start frequency, default -1 which means f_start = 10e-1 rad/s
- to:   exp10 of the stop frequency,  default 2 which means f_stop = 100 rad/s

Returns:
A tuple of the three vectors w, mag, phase
- w:     vector of frequencies in rad/s
- mag:   magnitude (gain), to convert into dB use `todb.(mag)`
- phase: phase in degrees
"""
function frequency_response(sys; from=-1, to=2)
    w = exp10.(LinRange(from, to, 1000));
    mag, phase, w1 = bode(sys, w)
    w, mag[:], phase[:]
end

todb(mag) = 20 * log10(mag)

"""
    bode_plot(sys::Union{StateSpace, TransferFunction}; title="", from=-3, to=1, fig=true, db=true)

Create a bode plot of a linear system. Parameters:
- title (String)
- from  (min frequency in rad/s, default -3, means 1e-3)
- to    (max frequency in rad/s, default  1, means 1e1)
- fig   (default true, create a new figure)
- db    (default true, use decibel as unit for the magnitude)
- hz    (default true, use Hz as unit for the frequency)

Returns:
nothing
"""
function bode_plot(sys::Union{StateSpace, TransferFunction}; title="", from=-1, to=1, fig=true, 
                   db=true, hz=true, bw=false, linestyle="solid", title_=true, fontsize=18)
    if fig; plt.figure(title, figsize=(8, 6)); end
    ax1 = plt.subplot(211) 
    w, mag, phase = frequency_response(sys; from, to)
    if hz
        w = w / (2 * π)
    end
    if db
        if bw
            ax1.plot(w, todb.(mag), color="black", linestyle=linestyle)
        else
            ax1.plot(w, todb.(mag))
        end
        ax1.set_xscale("log")
        plt.setp(ax1.get_xticklabels(), visible=false)
        plt.ylabel("Magnitude [dB]", fontsize = fontsize)
    else
        plt.loglog(w, mag, label=lbl)
        plt.ylabel("Magnitude", fontsize = fontsize)
    end
    plt.xlim(w[begin], w[end])
    if hz
        plt.xlabel("Frequency [Hz]", fontsize = fontsize)
    else    
        plt.xlabel("Frequency [rad/s]", fontsize = fontsize)
    end
    plt.grid(true, which="both", ls="-.")
    if title_
        plt.title(title, fontsize = fontsize)
    end
    ax2 = plt.subplot(212, sharex=ax1) 
    if bw
        ax2.plot(w, phase, color="black", linestyle=linestyle)
    else
        ax2.plot(w, phase)
    end

    ax2.set_xscale("log")
    ax2.grid(true, which="both", ls="-.")
    plt.ylabel("Phase [deg]", fontsize = fontsize)
    if hz
        plt.xlabel("Frequency [Hz]", fontsize = fontsize)
    else    
        plt.xlabel("Frequency [rad/s]", fontsize = fontsize)
    end 
    plt.subplots_adjust(hspace=0.05, bottom=0.11, right=0.97, left=0.11)
    if title == ""
        plt.subplots_adjust(top=0.97)
    else
        plt.subplots_adjust(top=0.94)
    end
    # plt.plshow(block=false)
    nothing
end


