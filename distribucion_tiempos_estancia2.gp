reset
set terminal pngcairo enhanced font "sans,11" size 900, 500

A    = "1.0"
etas = "0.01 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00 2.00 3.00 4.00 5.00"

set xlabel "Tiempo de estancia t"
set ylabel "Densidad de Probabilidad P(t)"
set grid
set key top right box

# 1. Histograma (ancho de barra adaptado a cada eta)
bin(x, w) = w * (floor(x / w) + 0.5)

# 2. Estilo de las cajas (relleno con borde)
set style fill solid 0.5 border lc rgb "#1c3b82"

do for [e in etas] {
    archivo = sprintf("resultados/doblepozo_eta%s_A%s.dat_tiempos.dat", e, A)
    set output sprintf("plots objetivo 2/histogramas/distribucion_tiempos_eta%s_A%s.png", e, A)
    set title sprintf("Distribución de Tiempos de Estancia P(t) {/Symbol h}=%s, A=%s", e, A)

    # 3. Factor de normalización empírico (stats sin escala log ni rangos)
    unset logscale
    set autoscale
    stats archivo using 1 nooutput
    N_saltos = STATS_records + 0.0
    tau_exp  = STATS_mean
    binwidth = tau_exp / 8.0
    set boxwidth binwidth
    peso     = 1.0 / (N_saltos * binwidth)

    # Recta teórica
    tau_m = tau_exp
    P_teor(t) = (1.0 / tau_m) * exp(-t / tau_m)

    # 4. Escala logarítmica y límites en los ejes (relativos a <tau>)
    set logscale y
    set xrange [0 : 8.0 * tau_exp]
    set yrange [1e-4 / tau_exp : 2.0 / tau_exp]

    # 5. Trazar con cajas (with boxes)
    plot archivo using (bin($1, binwidth)):(peso) smooth frequency with boxes \
         lc rgb "#4169e1" \
         title sprintf("Simulación (<{/Symbol t}>_{exp} = %.2f)", tau_exp), \
         P_teor(x) with lines lw 2.2 lc rgb "red" dt 1 \
         title "Ajuste Poisson: P(t) = (1/<{/Symbol t}>) e^{-t/<{/Symbol t}>}"

    set output
}
