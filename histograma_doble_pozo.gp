set terminal pngcairo enhanced font "sans,11" size 900, 500
set grid back lc rgb "#e8e8e8" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1

set xlabel "Posición x" font "sans-bold,11"
set ylabel "Densidad de Probabilidad P(x)" font "sans-bold,11"
set xrange [-1.8:1.8]

binwidth = 0.04
bin(x, width) = width * (floor(x / width) + 0.5)

kbT = 0.2
etas = "0.01 0.10 1.00 5.00"
alturas_A = "0.5 1.0 2.0"

set style fill solid 0.45 border lc rgb "#333333"

do for [eta_val in etas] {
    do for [A_str in alturas_A] {
        A_val = A_str + 0.0

        set output sprintf("histograma_posicion_eta%s_A%s.png", eta_val, A_str)
        set title sprintf("Distribución P(x) ({/Symbol h} = %s, A = %s, k_B T = 0.2)", eta_val, A_str) font "sans-bold,12"

        fichero = sprintf("resultados/doblepozo_eta%s_A%s.dat", eta_val, A_str)

        # Normalización a partir de los registros del archivo
        stats fichero using 4 nooutput
        N_puntos = STATS_records

        V(x) = A_val * (x**2 - 1.0)**2
        P_sin_norm(x) = exp(-V(x) / kbT)

        norm_factor = (A_val == 0.5) ? 0.72 : (A_val == 1.0 ? 0.98 : 1.35)
        color_hist = (A_str eq "0.5") ? "#1b9e77" : (A_str eq "1.0" ? "#d95f02" : "#7570b3")

        plot fichero using (bin($4, binwidth)):(1.0 / (N_puntos * binwidth)) \
             smooth frequency with boxes lc rgb color_hist title "Histograma Simulación", \
             P_sin_norm(x) * norm_factor with lines lc rgb "#111111" lw 2 dt 1 title "Teoría Boltzmann"
    }
}

set output