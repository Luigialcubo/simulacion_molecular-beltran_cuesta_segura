set terminal pngcairo enhanced font "sans,11" size 900, 650

# Estilos de línea
set style line 2 lc rgb "#e41a1c" lt 1 lw 1.2   # Euler-Maruyama (rojo)
set style line 3 lc rgb "#377eb8" lt 1 lw 1.2   # Runge-Kutta 2 (azul)
set style line 4 lc rgb "#4daf4a" lt 1 lw 1.2   # Verlet G-JF (verde)

set grid back lc rgb "#e0e0e0" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1

set xlabel "Tiempo t"
set ylabel "Posición x(t)"
set key top right box opaque

# En un oscilador armónico con k=1 y T=1, <x^2> = 1 (sigma = 1).
# Las oscilaciones normales están en el rango [-3, 3].
# Fijamos el eje Y para evitar que una divergencia de Euler rompa la escala:
set yrange [-3.5:3.5]

etas = "0.1 1.0 10.0"
hs   = "0.0001 0.0010 0.0100 0.1000"

do for [eta in etas] {
    do for [h in hs] {
        set output sprintf("trayectoria_eta%s_h%s.png", eta, h)
        set title sprintf("Trayectoria x(t) (eta = %s, h = %s)", eta, h)

        f0 = sprintf("resultados/data_alg0_eta%.1f_h%.4f.dat", real(eta), real(h))
        f1 = sprintf("resultados/data_alg1_eta%.1f_h%.4f.dat", real(eta), real(h))
        f2 = sprintf("resultados/data_alg2_eta%.1f_h%.4f.dat", real(eta), real(h))

        # OPCIÓN A: Ventana corta de tiempo para ver las ondas (descomenta si prefieres una ventana fija)
        # set xrange [2000:2100]

        # OPCIÓN B: Rango dinámico (inicia donde empiezan los datos y llega a 10000)
        set autoscale xfixmin
        set xrange [2000:2100]

        # Columna 3 = tiempo t | Columna 4 = posición x
        plot f0 using 3:4 title "Euler-Maruyama" with lines ls 2, \
             f1 using 3:4 title "Runge-Kutta 2" with lines ls 3, \
             f2 using 3:4 title "Verlet (G-JF)" with lines ls 4
    }
}
set output