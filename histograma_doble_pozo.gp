# Configuración general
set terminal pngcairo enhanced font "sans,11" size 900, 500
set xlabel "Posición x"
set ylabel "Densidad de Probabilidad P(x)"

# Rango en X y ancho de caja
set xrange [-1.8:1.8]
set autoscale y
binwidth = 0.04

# Función que asigna valor x al centro de la caja
bin(x, w) = w * (floor(x / w) + 0.5)

# Parámetros de simulación
kbT = 0.2
alturas_A = "0.5 1.0 2.0"
etas = "0.01 0.10 1.00 5.00"

do for [eta_val in etas] {
    do for [A_txt in alturas_A] {
        
        A_val = A_txt + 0.0

        fichero_datos = sprintf("resultados/doblepozo_eta%s_A%s.dat", eta_val, A_txt)
        
        # 1. Contar registros reales de la columna 4
        stats fichero_datos using 4 nooutput
        N = STATS_records + 0.0

        # 2. Factor de normalización experimental
        peso = 1.0 / (N * binwidth)

        # 3. Integral teórica de Boltzmann
        dx_int = 0.0005
        Z_val = 0.0
        x_eval = -3.0
        while (x_eval <= 3.0) {
            V_eval = A_val * ((x_eval**2 - 1.0)**2)
            Z_val = Z_val + exp(-V_eval / kbT) * dx_int
            x_eval = x_eval + dx_int
        }

        # Densidad teórica normalizada
        P_teor(x) = exp( -(A_val * ((x**2 - 1.0)**2)) / kbT ) / Z_val

        # 4. Calcular el área experimental real mediante una tabla temporal
        set table "temp_hist.dat"
        plot fichero_datos using (bin($4, binwidth)):(peso) smooth frequency
        unset table

        stats "temp_hist.dat" using ($2 * binwidth) nooutput
        area_exp = STATS_sum

        # 5. Área teórica integrada
        area_teor = 0.0
        x_eval = -3.0
        while (x_eval <= 3.0) {
            area_teor = area_teor + P_teor(x_eval) * dx_int
            x_eval = x_eval + dx_int
        }

        # 6. Generar la imagen PNG con ambos resultados superpuestos
        set output sprintf("plots objetivo 2/histogramas/histograma_eta%s_A%s.png", eta_val, A_txt)
        set title sprintf("P(x) Doble Pozo (eta = %s, A = %s, k_B T = 0.2)", eta_val, A_txt)
        
        plot fichero_datos using (bin($4, binwidth)):(peso) \
             smooth frequency with boxes lc rgb "#9400d3" title "Simulacion", \
             P_teor(x) with lines lw 2 lc rgb "#00aa00" title "Teoria Boltzmann"

        set output

        print sprintf("[eta = %4s | A = %3s] -> Area Exp = %.6f | Area Teor = %.6f", \
                      eta_val, A_txt, area_exp, area_teor)
    }
}