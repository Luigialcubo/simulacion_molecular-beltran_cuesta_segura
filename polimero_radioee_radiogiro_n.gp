set terminal pngcairo size 950,680 enhanced font "Arial,13"

set title "Comparación de Leyes de Escala: <R_{ee}^2> y <R_G^2> (FJC, k_e = 1000)"
set xlabel "Número de monómeros (N)"
set ylabel "Distancia cuadrática media"

# Escala doble logarítmica
set logscale xy
set xrange [3:80]
set yrange [0.3:180]
set grid xtics ytics mxtics mytics lw 0.5 lc rgb "#dddddd"
set key top left box opaque

# Longitud cuadrática media efectiva del muelle (b=1, k_e=100, kBT=1)
l2 = 1.03

# 1. Rectas teóricas asintóticas
teorica_ree2(x) = l2 * x
teorica_rg2(x)  = (l2 / 6.0) * x

# 2. Ajustes lineales independientes en log-log
ajuste_ree2(x) = a_ee + m_ee * x
fit ajuste_ree2(x) "resultados/escala_rg2.dat" using (log($1)):(log($4)) via a_ee, m_ee
leyenda_fit_ee = sprintf("Ajuste <R_{ee}^2> (2{/Symbol n} = %.3f)", m_ee)

ajuste_rg2(x) = a_g + m_g * x
fit ajuste_rg2(x) "resultados/escala_rg2.dat" using (log($1)):(log($2)) via a_g, m_g
leyenda_fit_g = sprintf("Ajuste <R_G^2> (2{/Symbol n} = %.3f)", m_g)

# ==========================================
# IMAGEN 1: CON FIT
# ==========================================
set output "plots objetivo 3/comparacion_Ree2_Rg2_con_fit_ke1000.png"

plot "resultados/escala_rg2.dat" using 1:4 with points pt 7 ps 1.4 lc rgb "#cc0000" title "Simulación <R_{ee}^2>", \
     exp(a_ee) * x**m_ee with lines lw 2 lc rgb "#cc0000" title leyenda_fit_ee, \
     teorica_ree2(x) with lines lw 2 dt 2 lc rgb "#880000" title "Teórica <R_{ee}^2>: <l^2> N", \
     "resultados/escala_rg2.dat" using 1:2 with points pt 5 ps 1.4 lc rgb "#004488" title "Simulación <R_G^2>", \
     exp(a_g) * x**m_g with lines lw 2 lc rgb "#004488" title leyenda_fit_g, \
     teorica_rg2(x) with lines lw 2 dt 2 lc rgb "#002244" title "Teórica <R_G^2>: (<l^2>/6) N"

unset output

# ==========================================
# IMAGEN 2: SIN FIT (Más limpia visualmente)
# ==========================================
set output "plots objetivo 3/comparacion_Ree2_Rg2_sin_fit_ke1000.png"

plot "resultados/escala_rg2.dat" using 1:4 with points pt 7 ps 1.4 lc rgb "#cc0000" title "Simulación <R_{ee}^2>", \
     teorica_ree2(x) with lines lw 2 dt 2 lc rgb "#cc0000" title "Teórica <R_{ee}^2>: <l^2> N", \
     "resultados/escala_rg2.dat" using 1:2 with points pt 5 ps 1.4 lc rgb "#004488" title "Simulación <R_G^2>", \
     teorica_rg2(x) with lines lw 2 dt 2 lc rgb "#004488" title "Teórica <R_G^2>: (<l^2>/6) N"

unset output