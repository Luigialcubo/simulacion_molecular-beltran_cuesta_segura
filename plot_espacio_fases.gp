set terminal pngcairo enhanced font "sans,11" size 800, 800

# Proporción 1:1 para que las elipses u órbitas no se deformen
set size square

set grid back lc rgb "#e0e0e0" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1

set xlabel "Posición x"
set ylabel "Velocidad / Momento p"
set key top right box opaque

# Rangos simétricos basados en las fluctuaciones térmicas (sigma = 1)
set xrange [-3.5:3.5]
set yrange [-3.5:3.5]

# Estilos de línea
set style line 2 lc rgb "#e41a1c" lt 1 lw 1.0   # Euler-Maruyama (rojo)
set style line 3 lc rgb "#377eb8" lt 1 lw 1.0   # Runge-Kutta 2 (azul)
set style line 4 lc rgb "#4daf4a" lt 1 lw 1.0   # Verlet G-JF (verde)

etas = "0.1 1.0 10.0"
hs   = "0.0001 0.0010 0.0100 0.1000"

do for [eta in etas] {
    do for [h in hs] {
        set output sprintf("espacio_fases_eta%s_h%s.png", eta, h)
        set title sprintf("Espacio de fases (p vs x) (eta = %s, h = %s)", eta, h)

        f0 = sprintf("resultados/data_alg0_eta%.1f_h%.4f.dat", real(eta), real(h))
        f1 = sprintf("resultados/data_alg1_eta%.1f_h%.4f.dat", real(eta), real(h))
        f2 = sprintf("resultados/data_alg2_eta%.1f_h%.4f.dat", real(eta), real(h))

        # Columna 4 = posición x | Columna 5 = velocidad p
        # Usamos un filtro de tiempo para graficar un tramo representativo (t entre 2000 y 2100)
        # para que se aprecie la órbita sin que se vuelva una mancha uniforme:
        plot f0 using ( ($3 >= 2000 && $3 <= 2100) ? $4 : 1/0 ):5 title "Euler-Maruyama" with lines ls 2, \
             f1 using ( ($3 >= 2000 && $3 <= 2100) ? $4 : 1/0 ):5 title "Runge-Kutta 2" with lines ls 3, \
             f2 using ( ($3 >= 2000 && $3 <= 2100) ? $4 : 1/0 ):5 title "Verlet (G-JF)" with lines ls 4
    }
}
set output