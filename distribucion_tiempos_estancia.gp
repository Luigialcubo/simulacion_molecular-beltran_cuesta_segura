set terminal pngcairo enhanced font "sans,11" size 900, 500
set output "plots objetivo 2/distribucion_tiempos_simulacion_A=1.0.png"

set title "Distribución de Tiempos de Estancia P(t) eta=1.0, A=1.0"
set xlabel "Tiempo de estancia t"
set ylabel "Densidad de Probabilidad P(t)"
set grid
set key top right box

# 1. Parámetros del histograma y ancho de barras uniforme
binwidth = 50.0
set boxwidth binwidth
bin(x, w) = w * (floor(x / w) + 0.5)

# 2. Estilo de las cajas (relleno con borde)
set style fill solid 0.5 border lc rgb "#1c3b82"

archivo = "resultados/doblepozo_eta1.00_A1.0.dat_tiempos.dat"

# 3. Factor de normalización empírico
set autoscale
stats archivo using 1 nooutput
N_saltos = STATS_records + 0.0
tau_exp  = STATS_mean
peso     = 1.0 / (N_saltos * binwidth)

#Recta teórica
tau_m = tau_exp
P_teor(t) = (1.0 / tau_m) * exp(-t / tau_m)

# 4. Escala logarítmica y límites en los ejes
set logscale y
set yrange [1e-5 : 0.01]
set xrange [0:2500]

# 5. Trazar con cajas (with boxes)
plot archivo using (bin($1, binwidth)):(peso) smooth frequency with boxes \
     lc rgb "#4169e1" \
     title sprintf("Simulación (<{/Symbol t}>_{exp} = %.2f)", tau_exp), \
     P_teor(x) with lines lw 2.2 lc rgb "red" dt 1 \
     title "Ajuste Poisson: P(t) = (1/<{/Symbol t}>) e^{-t/<{/Symbol t}>}"

set output