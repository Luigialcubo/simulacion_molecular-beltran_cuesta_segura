set terminal pngcairo enhanced font "sans,11" size 1050, 600
set output "probabilidad_ocupacion_vs_fuerza.png"

set title "Probabilidad de ocupación en función de la fuerza externa F_{ext}  (A = 1, k_BT = 0.2)"
set xlabel "Fuerza externa F_{ext}"
set ylabel "Probabilidad P"
set grid
set xrange [-1.0 : 1.0]
set yrange [-0.05 : 1.05]
set key outside top center horizontal maxrows 2 box opaque spacing 1.4 width 1

# 1. Curvas teóricas (equilibrio de Boltzmann entre los dos pozos, x_0 = 1)
kbT = 0.2
x0  = 1.0
P_der_teor(f) = 1.0 / (1.0 + exp(-2.0 * f * x0 / kbT))
P_izq_teor(f) = 1.0 / (1.0 + exp(+2.0 * f * x0 / kbT))

# Línea discontinua de referencia en P = 0.5
set arrow from -1.0, 0.5 to 1.0, 0.5 nohead dt 2 lc rgb "#888888"

# 2. Archivo de datos (columna 1: F_ext, col 2: P(x>0), col 3: P(x<0))
archivo = "resultados/fuerza_cte.dat"

plot P_der_teor(x) with lines lw 2 lc rgb "#1b9e77" \
         title "Teoría  P(x>0) = 1 / (1 + e^{-2F_{ext}x_0 / k_BT})", \
     P_izq_teor(x) with lines lw 2 lc rgb "#d95f02" \
         title "Teoría  P(x<0) = 1 / (1 + e^{+2F_{ext}x_0 / k_BT})", \
     archivo using 1:2 with points pt 7 ps 1.3 lc rgb "#0e664d" title "Simulación P(x > 0)", \
     archivo using 1:3 with points pt 7 ps 1.3 lc rgb "#a63603" title "Simulación P(x < 0)"

set output
