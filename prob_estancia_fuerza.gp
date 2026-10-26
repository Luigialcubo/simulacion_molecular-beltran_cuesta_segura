set terminal pngcairo enhanced font "sans,11" size 800, 500
set output "plots objetivo 2/probabilidades_fuerza.png"

set grid back lc rgb "#e6e6e6" lt 1 lw 1
set border 31 lc rgb "#333333" lw 1

set title "Probabilidad de ocupación en función de la fuerza externa F_{ext}" font "sans-bold,12"
set xlabel "Fuerza externa F_{ext}" font "sans-bold,11"
set ylabel "Probabilidad P" font "sans-bold,11"

# Rango de probabilidad acotado entre 0 y 1
set xrange [-0.35:0.35]
set yrange [-0.05:1.05]

# Configuración de leyenda
set key top left box lc rgb "#cccccc" spacing 1.3

# Línea discontinua de simetría en P = 0.5
set arrow 1 from -0.35, 0.5 to 0.35, 0.5 nohead lc rgb "#aaaaaa" dt 2 lw 1

fichero = "resultados/fuerza_cte.dat"

plot fichero using 1:2 title "P(x > 0) [Pozo derecho]" with linespoints pt 7 ps 0.8 lw 1.5 lc rgb "#1b9e77", \
     fichero using 1:3 title "P(x < 0) [Pozo izquierdo]" with linespoints pt 7 ps 0.8 lw 1.5 lc rgb "#d95f02"

set output