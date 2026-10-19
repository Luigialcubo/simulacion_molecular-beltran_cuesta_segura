set terminal pngcairo enhanced font "sans,11" size 850, 500
set grid back lc rgb "#e6e6e6" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1

set xlabel "Tiempo t" font "sans-bold,11"
set ylabel "Posición x(t)" font "sans-bold,11"

# Eje Y: cubriendo holgadamente los dos pozos (-1 y +1)
set yrange [-1.8:1.8]

# Eje X: ventana representativa para ver la dinámica sin que se sature
# (puedes ajustar el intervalo, por ejemplo [0:2000] o [1000:3000])
set xrange [0:2000]

# Línea discontinua que señala la cima inestable de la barrera (x = 0)
set arrow from 0,0 to 2000,0 nohead lc rgb "#888888" dt 2 lw 1.2

# Quitar la caja de leyenda vacía que salía arriba
unset key

etas = "0.01 0.10 1.00 5.00"
alturas_A = "0.5 1.0 2.0"

do for [eta in etas] {
    do for [A_val in alturas_A] {
        set output sprintf("plots objetivo 2/trayectorias/trayectoria_x_eta%s_A%s.png", eta, A_val)
        set title sprintf("Trayectoria x(t) en doble pozo ({/Symbol h} = %s, A = %s, k_B T = 0.2)", eta, A_val) font "sans-bold,11"

        fichero = sprintf("resultados/doblepozo_eta%s_A%s.dat", eta, A_val)

        # Color distintivo por barrera A
        color_linea = (A_val eq "0.5") ? "#1b9e77" : \
                      (A_val eq "1.0") ? "#d95f02" : "#7570b3"

        # Trazo más fino (lw 0.7) para evitar manchas de tinta
        plot fichero using 3:4 notitle with lines lc rgb color_linea lw 0.7
    }
}

set output