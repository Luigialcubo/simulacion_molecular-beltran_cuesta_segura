set terminal pngcairo size 900,650 enhanced font "Arial,13"

set title "Ley de escala del Radio de Giro cuadrático medio (FJC, k_e = 100)"
set xlabel "Número de monómeros (N)"
set ylabel "<R_G^2>"

# Escala doble logarítmica (aquí las potencias salen rectas)
set logscale xy
set xrange [3:80]
set yrange [0.3:20]
set grid xtics ytics mxtics mytics lw 0.5 lc rgb "#dddddd"
set key top left box opaque

# Longitud cuadrática media efectiva del muelle (b=1, k_e=100, kBT=1 -> 1 + 3*kBT/ke = 1.03)
l2 = 1.03

# 1. Recta teórica asintótica: <Rg^2> = (<l^2>/6) * N^1  --> pendiente = 1
teorica_recta(x) = (l2 / 6.0) * x

# 2. Curva teórica exacta (Debye discreta): <Rg^2> = (<l^2>/6) * (N^2 - 1)/N
teorica_exacta(x) = (l2 / 6.0) * (x**2 - 1.0) / x

# 3. Ajuste lineal de tus datos en log-log para comprobar tu exponente experimental
ajuste(x) = a + m * x
fit ajuste(x) "resultados/escala_rg2.dat" using (log($1)):(log($2)) via a, m
leyenda_fit = sprintf("Ajuste simulación (pendiente 2{/Symbol n} = %.3f)", m)

# ==========================================
# IMAGEN 1: CON FIT
# ==========================================
set output "plots objetivo 3/radiosgiro/ley_escala_Rg2_con_fit.png"

plot "resultados/escala_rg2.dat" using 1:2 with points pt 7 ps 1.4 lw 1.5 lc rgb "#004488" title "Simulación <R_G^2>", \
     exp(a) * x**m with lines lw 2 lc rgb "#004488" title leyenda_fit, \
     teorica_recta(x) with lines lw 2 dt 2 lc rgb "#cc0000" title "Teórica asintótica: (<l^2>/6) N^{1.0}" #, \
    # teorica_exacta(x) with lines lw 2 dt 3 lc rgb "#008833" title "Teórica exacta: (<l^2>/6)(N^2-1)/N"

unset output

# ==========================================
# IMAGEN 2: SIN FIT
# ==========================================
set output "plots objetivo 3/radiosgiro/ley_escala_Rg2_sin_fit.png"

plot "resultados/escala_rg2.dat" using 1:2 with points pt 7 ps 1.4 lw 1.5 lc rgb "#004488" title "Simulación <R_G^2>", \
     teorica_recta(x) with lines lw 2 dt 2 lc rgb "#cc0000" title "Teórica asintótica: (<l^2>/6) N^{1.0}" #, \
    # teorica_exacta(x) with lines lw 2 dt 3 lc rgb "#008833" title "Teórica exacta: (<l^2>/6)(N^2-1