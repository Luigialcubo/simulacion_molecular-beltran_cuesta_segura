# ==== Tiempo medio de estancia <tau>(eta) para el doble pozo ====
# Ejecutar dentro de la carpeta "resultados":   load 'tiempos_medios.gp'
# Genera, para A = 0.5 y A = 1.0, dos graficas: escala lineal y escala log-log.

reset   # borra rangos/escalas que queden de graficas anteriores (stats los respeta)

As   = "0.5 1.0"
etas = "0.01 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00 2.00 3.00 4.00 5.00"

# 1) Calcula <tau> y su error para cada eta y lo guarda en tau_A<A>.dat
do for [A in As] {
    salida = sprintf("tau_A%s.dat", A)
    set print salida
    print "# eta  tau_medio  error  N_saltos"
    do for [e in etas] {
        f = sprintf("doblepozo_eta%s_A%s.dat_tiempos.dat", e, A)
        undefine STATS_*
        stats f u 1 nooutput
        if (exists("STATS_mean")) {
            print e, STATS_mean, STATS_stddev/sqrt(STATS_records), STATS_records
        } else {
            printerr "AVISO: no se han podido leer datos de ", f
        }
    }
    set print
}

# 2) Estilo comun (igual que tus graficas anteriores)
set terminal pngcairo size 1920,920 enhanced font "Verdana,14"
set xlabel "Amortiguamiento {/Symbol h}"
set ylabel "Tiempo medio <{/Symbol t}>({/Symbol h})"
set grid xtics ytics lt 0 lw 1 lc rgb "#bbbbbb"
set key top left box opaque

do for [A in As] {
    salida = sprintf("tau_A%s.dat", A)
    set title sprintf("Tiempo Medio de Estancia frente al Amortiguamiento (A = %s)", A)

    # --- Escala lineal ---
    unset logscale
    set xrange [0:5.1]
    set yrange [0:*]
    set mxtics 5
    set mytics 5
    set output sprintf("tiempo_medio_vs_eta_A%s.png", A)
    plot salida u 1:2 w points pt 7 ps 1.5 lc rgb "#1f3a7a" t sprintf("Simulación (A = %s)", A)
    set output

    # --- Escala log-log ---
    set logscale xy
    set xrange [0.008:6]
    set yrange [*:*]
    set mxtics 10
    set mytics 10
    set output sprintf("tiempo_medio_vs_eta_A%s_log.png", A)
    plot salida u 1:2 w points pt 7 ps 1.5 lc rgb "#1f3a7a" t sprintf("Simulación (A = %s)", A)
    set output
}
