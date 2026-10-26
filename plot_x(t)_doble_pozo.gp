set terminal pngcairo enhanced font "sans,11" size 850, 500
set grid back lc rgb "#e6e6e6" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1

set xlabel "Tiempo t" font "sans-bold,11"
set ylabel "Posición x(t)" font "sans-bold,11"

# Eje Y: cubre ambos mínimos holgadamente
set yrange [-1.8:1.8]
unset key

etas = "0.01 0.10 1.00 5.00"
alturas_A = "0.5 1.0 2.0"

do for [eta in etas] {
    do for [A_val in alturas_A] {
        fichero = sprintf("resultados/doblepozo_eta%s_A%s.dat", eta, A_val)

        color_linea = (A_val eq "0.5") ? "#1b9e77" : \
                      (A_val eq "1.0") ? "#d95f02" : "#7570b3"

        # Definir el tiempo maximo segun el valor de A
        t_max_macro = (A_val eq "2.0") ? 500000 : 10000

        # ---------------------------------------------------------
        # 1. Grafica Macroscopica (ajustada dinamicamente)
        # ---------------------------------------------------------
        set xrange [0:t_max_macro]
        set arrow 1 from 0,0 to t_max_macro,0 nohead lc rgb "#888888" dt 2 lw 1.2

        set output sprintf("plots objetivo 2/trayectorias/macro_eta%s_A%s.png", eta, A_val)
        set title sprintf("Trayectoria Macro x(t) [{/Symbol h}=%s, A=%s, k_BT=0.2]", eta, A_val) font "sans-bold,11"
        plot fichero using 3:4 notitle with lines lc rgb color_linea lw 0.5

        # ---------------------------------------------------------
        # 2. Grafica Microscopica (zoom local)
        # ---------------------------------------------------------
        set xrange [500:700]
        set arrow 1 from 500,0 to 700,0 nohead lc rgb "#888888" dt 2 lw 1.2

        set output sprintf("plots objetivo 2/trayectorias/micro_eta%s_A%s.png", eta, A_val)
        set title sprintf("Trayectoria Detalle x(t) [{/Symbol h}=%s, A=%s, k_BT=0.2]", eta, A_val) font "sans-bold,11"
        plot fichero using 3:4 notitle with lines lc rgb color_linea lw 0.9
    }
}
set output