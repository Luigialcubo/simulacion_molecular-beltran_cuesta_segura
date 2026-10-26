set terminal pngcairo enhanced font "sans,11" size 900, 500
set output "plots objetivo 2/distribucion_tiempos_simulacion.png"

set title "Distribución de Tiempos de Estancia P(t)"
set xlabel "Tiempo de estancia t"
set ylabel "Densidad de Probabilidad P(t)"
set grid
set key top right box



binwidth = 10.0
bin(x, w) = w * (floor(x / w) + 0.5)

archivo = "resultados/doblepozo_eta1.00_A1.0.dat_tiempos.dat"

# 2. Contar eventos y calcular el factor de normalización
stats archivo using 1 nooutput
N_saltos = STATS_records + 0.0
tau_exp  = STATS_mean
peso     = 1.0 / (N_saltos * binwidth)


safe_y(val) = (val > 1e-12) ? val : 1e-12


#set logscale y e
set yrange [-12: 0]
set autoscale x

plot archivo using (bin($1, binwidth)):(safe_log(peso)) smooth frequency with steps \
    lw 2 lc rgb "#4169e1" \
    title sprintf("Simulación (<{/Symbol t}>_{exp} = %.2f)", tau_exp)

set output