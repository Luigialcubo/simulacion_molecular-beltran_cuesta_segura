# 1. Archivo final de salida
set print "tiempos_medios(eta)_A=0.5.txt"

# 2. Desactivar cualquier límite que impida leer los datos
set autoscale

etas = "0.01 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.60 0.70 0.80 0.90 1.00 2.00 3.00 4.00 5.00"
A_val = "0.5"

do for [eta_val in etas] {
    # Nombre exacto del archivo con los tiempos de estancia
    fichero = sprintf("resultados/doblepozo_eta%s_A%s.dat_tiempos.dat", eta_val, A_val)

    # Media simple de la columna 1 sin restricciones de rango [*:*]
    stats [*:*] fichero using 1 nooutput

    # Imprimir en el fichero: eta en columna 1 y media de la columna 1 en columna 2
    print sprintf("%-6s\t%.6f", eta_val, STATS_mean)
}

# 3. Cerrar el archivo
set print
print "Archivo 'tiempos_medios(eta)_A=0.5.txt' generado con exito con ambas columnas."