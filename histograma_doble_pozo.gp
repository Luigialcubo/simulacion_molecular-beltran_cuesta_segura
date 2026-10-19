# Configuración general
set terminal pngcairo enhanced font "sans,11" size 900, 500
set xlabel "Posición x"
set ylabel "Densidad de Probabilidad P(x)"

# Rango y ancho de caja
set xrange [-1.8:1.8]
binwidth = 0.04

# Función que asigna valor x al centro de la caja
bin(x, w) = w * (floor(x / w) + 0.5)

# Parámetros de simulación
kbT = 0.2
alturas_A = "0.5 1.0 2.0"
etas = "0.01 0.10 1.00 5.00"

do for [eta_val in etas] {
    do for [A_txt in alturas_A] {
        
        # Convertimos la cadena de texto de A en número para operar
        A_val = A_txt + 0.0

        # Construcción del nombre del archivo
        fichero_datos = sprintf("resultados/doblepozo_eta%s_A%s.dat", eta_val, A_txt)
        set output sprintf("histograma_eta%s_A%s.png", eta_val, A_txt)

        # Número total de datos N (columna 4: posición x)
        stats fichero_datos using 4 nooutput
        N = STATS_records

        # Cálculo de la función de partición Z
        dx_int = 0.0005
        Z_val = 0.0
        x_eval = -3.0
        while (x_eval <= 3.0) {
            Z_val = Z_val + exp(-A_val * (x_eval**2 - 1.0)**2 / kbT) * dx_int
            x_eval = x_eval + dx_int
        }

        # Densidad teórica normalizada
        P_teor(x) = exp(-A_val * (x**2 - 1.0)**2 / kbT) / Z_val

        # Gráfica del histograma y la curva analítica
        plot fichero_datos using (bin($4, binwidth)):(1.0 / (N * binwidth)) \
             smooth frequency with boxes title "Simulacion", \
             P_teor(x) with lines lw 2 title "Teoria Boltzmann"

        # Cierre del archivo
        set output

        # Área teórica integrada
        area_teor = 0.0
        x_eval = -3.0
        while (x_eval <= 3.0) {
            area_teor = area_teor + P_teor(x_eval) * dx_int
            x_eval = x_eval + dx_int
        }

        # Área del histograma experimental:
        #Peso suma
        stats fichero_datos using ( (1.0 / (N * binwidth)) * binwidth ) nooutput
        #Suma
        area_exp = STATS_sum

        print sprintf("[eta = %4s | A = %3s] -> Area Exp = %.6f | Area Teor = %.6f", \
                      eta_val, A_txt, area_exp, area_teor)
    }
}

