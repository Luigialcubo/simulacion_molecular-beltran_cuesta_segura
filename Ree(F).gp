N = 4
b = 1.0
kT = 1.0
L(x) = 1.0/tanh(x) - 1.0/x
set xlabel "F"
set ylabel "<Ree_x>"
set title "N = 4, k_e = 1000, k_BT = 1"
set key bottom right
set samples 1000
plot "resultados/fuerza_N4_eta0.1.dat" u 2:3 w p pt 7 ps 1.5 lc rgb "red" t "Simulacion", \
     (N-1)*b*L(x*b/kT) w l lw 2 lc rgb "blue" t "Langevin (enlaces rigidos)"