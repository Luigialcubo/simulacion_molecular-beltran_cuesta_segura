set terminal pngcairo enhanced font "sans,11" size 900, 500
set output "distribucion_tiempos_simulacion.png"

set title "Distribución de Tiempos de Estancia P(t)"
set xlabel "Tiempo de estancia t"
set ylabel "Densidad de Probabilidad P(t)"
set grid
set key top right box

# 1. Parámetros del histograma
set yrange [0:*]
set autoscale x

binwidth = 10.0
set boxwidth binwidth
bin(x, w) = w * (floor(x / w) + 0.5)

archivo = "resultados/doblepozo_eta1.00_A1.0.dat_tiempos.dat"

# 2. Contar eventos y calcular el factor de normalización
stats archivo using 1 nooutput
N_saltos = STATS_records + 0.0
tau_exp  = STATS_mean
peso     = 1.0 / (N_saltos * binwidth)

# 3. Dibujar el histograma experimental
set logscale y
plot archivo using (bin($1, binwidth)):(peso) smooth frequency with boxes \
         lc rgb "#4169e1" fill solid 0.5 border lc rgb "#1c3b82" \
         title sprintf("Simulación (<{/Symbol t}>_{exp} = %.2f)", tau_exp)

set output

# ==========================================================
# 4. COMPROBACIÓN NUMÉRICA DEL ÁREA EXPERIMENTAL
# ==========================================================

# Guardamos las barras reales calculadas por Gnuplot en una tabla temporal
set table "temp_tiempos_hist.dat"
plot archivo using (bin($1, binwidth)):(peso) smooth frequency
unset table

# Sumamos el área de todas las cajas (altura en columna 2 * ancho binwidth)
stats "temp_tiempos_hist.dat" using ($2 * binwidth) nooutput
area_exp = STATS_sum

# Imprimir el resultado por la consola de Gnuplot
print "--------------------------------------------------"
print sprintf("Total saltos registrados (N) = %d", N_saltos)
print sprintf("Tiempo medio medido (<tau>)   = %.4f", tau_exp)
print sprintf("Área total del histograma    = %.6f", area_exp)
print "--------------------------------------------------"