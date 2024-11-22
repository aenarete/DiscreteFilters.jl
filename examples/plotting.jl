##########################################################################################
#               The following plots are bode plots in the frequency domain               #
##########################################################################################

"""
    bode_plot(sys::Union{StateSpace, TransferFunction}; title="", from=-3, to=1, fig=true, 
                                                                  db=true, Γ0=nothing)

Create a bode plot of a linear system. Parameters:
- title (String)
- from  (min frequency in rad/s, default -3, means 1e-3)
- to    (max frequency in rad/s, default  1, means 1e1)
- fig   (default true, create a new figure)
- db    (default true, use dezibel as unit for the magnitude)
- Γ0    (default nothing, if a value is passed it is attached as label to the plot)

Returns:
`max_mag_db, omega_max` (max gain and frequency of max gain in rad/s)
"""
function bode_plot(sys::Union{StateSpace, TransferFunction}; title="", from=-3, to=1, fig=true, 
                   db=true, Γ0=nothing, bw=false, linestyle="solid", title_=true, fontsize=18, w_ex=0.0)
    if isnothing(Γ0)
        lbl=""
    else
        lbl = @sprintf "Γ: %.2f" Γ0
    end
    if fig; plt.figure(title, figsize=(8, 6)); end
    ax1 = plt.subplot(211) 
    w, mag, phase = frequency_response(sys; from, to)
    if db
        if bw
            ax1.plot(w, todb.(mag), label=lbl, color="black", linestyle=linestyle)
        else
            ax1.plot(w, todb.(mag), label=lbl)
        end
        ax1.set_xscale("log")
        plt.setp(ax1.get_xticklabels(), visible=false)
        plt.ylabel("Magnitude [dB]", fontsize = fontsize)
    else
        plt.loglog(w, mag, label=lbl)
        plt.ylabel("Magnitude", fontsize = fontsize)
    end
    plt.xlim(w[begin], w[end])
    plt.xlabel("Frequency [rad/s]", fontsize = fontsize)
    plt.grid(true, which="both", ls="-.")
    if title_
        plt.title(title, fontsize = fontsize)
    end
    if ! isnothing(Γ0)
        plt.legend()
    end
    ax2 = plt.subplot(212, sharex=ax1) 
    if bw
        ax2.plot(w, phase, color="black", linestyle=linestyle)
    else
        ax2.plot(w, phase)
    end

    if w_ex != 0.0 && (! isnothing(Γ0) && Γ0 < 1)
        corr = +8 # adds a little correction to put annotation right
        ind = findfirst(>=(w_ex), w)
        plt.plot(w_ex, phase[ind], linewidth=1, marker ="+", color="black", markersize=30)
        plt.annotate(L"~ω_{ex}",  xy=(w_ex, phase[ind]+corr), fontsize = fontsize)
    end

    ax2.set_xscale("log")
    ax2.grid(true, which="both", ls="-.")
    plt.ylabel("Phase [deg]", fontsize = fontsize)
    plt.xlabel("Frequency [rad/s]", fontsize = fontsize)
    plt.subplots_adjust(hspace=0.05, bottom=0.11, right=0.97, left=0.11)
    if title == ""
        plt.subplots_adjust(top=0.97)
    else
        plt.subplots_adjust(top=0.94)
    end
    plt.plshow(block=false)
    max_mag_db, index = findmax(todb.(mag))
    omega_max = w[index]
    max_mag_db, omega_max
end

