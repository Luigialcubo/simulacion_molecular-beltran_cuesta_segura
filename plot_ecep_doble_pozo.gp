set terminal pngcairo enhanced font "sans,11" size 850, 500
set grid back lc rgb "#e6e6e6" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1

set xlabel "Tiempo t" font "sans-bold,11"
set ylabel "Energía Promedio"

# Eje Y: cubriendo holgadamente los dos pozos (-1 y +1)
set yrange [0:0.2]

# Eje X: ventana representativa para ver la dinámica sin que se sature
# (puedes ajustar el intervalo, por ejemplo [0:2000] o [1000:3000])
set xrange [0:100000]





etas = "0.01 0.10 1.00 5.00"
alturas_A = "0.5 1.0 2.0"

do for [eta in etas] {
    do for [A_val in alturas_A] {
        set output sprintf("plots objetivo 2/energias/energias_eta%s_A%s.png", eta, A_val)
        set title sprintf("Energias cinetica y potencial ({/Symbol h} = %s, A = %s, k_B T = 0.2)", eta, A_val) font "sans-bold,11"

        fichero = sprintf("resultados/doblepozo_eta%s_A%s.dat", eta, A_val)

    
        if(A_val == 2.0){
            set xrange [0:1000000]
        } else {
            set xrange [0:100000]
        }

        plot 0.1 dt 2 lc rgb "black", \
            fichero u 3:2 w l lw 2 lc rgb "red" title "<Ec> Cinética (Cumple Equipartición)", \
            fichero u 3:1 w l lw 2 lc rgb "blue" title "<Ep> Potencial (No es 1/2 kBT)"
    }
}

set output