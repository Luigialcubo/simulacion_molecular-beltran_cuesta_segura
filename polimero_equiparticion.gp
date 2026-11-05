set terminal pngcairo enhanced font "sans,11" size 800, 500
set grid back lc rgb "#e0e0e0" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1
set key right center box opaque

set xlabel "Tiempo t" font "sans-bold,11"
set ylabel "Energía promedio normalizada" font "sans-bold,11"
set yrange [0:1.8]
set xrange [0:60000]

# Lista con todos los valores de N del guion
tamanos_N = "4 8 16 32 64"
eta_val = "0.1"

do for [n in tamanos_N] {
    # Nombre de salida dinámico
    set output sprintf("plots objetivo 3/equiparticion/equiparticion_polimero_N%s.png", n)
    set title sprintf("Equipartición de la Energía en Polímero 3D (N = %s, {/Symbol h} = %s)", n, eta_val) font "sans-bold,12"

    archivo = sprintf("resultados/polimero_N%s_eta%s.dat", n, eta_val)

    plot archivo using 1:2 with lines lw 1.8 lc rgb "#e41a1c" title sprintf("<E_c> / N (Simulación N=%s)", n), \
         1.5 with lines dt 2 lw 1.5 lc rgb "#111111" title "Teoría <E_c>/N = 1.5", \
         archivo using 1:3 with lines lw 1.8 lc rgb "#377eb8" title sprintf("<E_p> / (N-1) (Simulación N=%s)", n), \
         0.51 with lines dt 2 lw 1.5 lc rgb "#555555" title "Teoría <E_p>/(N-1) = 0.51"
}

set output