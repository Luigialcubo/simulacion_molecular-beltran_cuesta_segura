set terminal pngcairo enhanced font "sans,11" size 900, 650

# Eje X: inicio automatico (*), maximo fijado en 10000
set xrange [*:15000]

# Eje Y: fijado entre 0 y 1.5 para contener explosiones de Euler-Maruyama
set yrange [0:1.5]

set grid back lc rgb "#e0e0e0" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1

set xlabel "Tiempo t"
set ylabel "Energia cinetica promedio <Ec>"
set key top right box opaque

set style line 1 lc rgb "#222222" lt 2 lw 2.0
set style line 2 lc rgb "#e41a1c" lt 1 lw 1.5
set style line 3 lc rgb "#377eb8" lt 1 lw 1.5
set style line 4 lc rgb "#4daf4a" lt 1 lw 1.5

etas = "0.1 1.0 10.0"
hs   = "0.0001 0.0010 0.0100 0.1000"

do for [eta in etas] {
    do for [h in hs] {
        set output sprintf("equiparticion_eta%s_h%s_fijo.png", eta, h)
        set title sprintf("Equiparticion de la energia (eta = %s, h = %s)", eta, h)

        f0 = sprintf("resultados/data_alg0_eta%.1f_h%.4f.dat", real(eta), real(h))
        f1 = sprintf("resultados/data_alg1_eta%.1f_h%.4f.dat", real(eta), real(h))
        f2 = sprintf("resultados/data_alg2_eta%.1f_h%.4f.dat", real(eta), real(h))

	plot f2 using 3:(0.5) title "Teoria (<Ec> = 0.5)" with lines ls 1, \
             f0 using 3:2 title "Euler-Maruyama" with lines ls 2, \
             f1 using 3:2 title "Runge-Kutta 2" with lines ls 3, \
             f2 using 3:2 title "Verlet (G-JF)" with lines ls 4
    }
}
set output