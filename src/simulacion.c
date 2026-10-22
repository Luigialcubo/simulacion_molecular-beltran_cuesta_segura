#include "simulacion.h"
#include "integrators.h"
#include "stdio.h"


// Obtiene los pasos de termalización.
long long thermalization_steps(double eta, double h, double* t_term) {
	//Frecuencia angular del sistema
	double omega0 = sqrt(K_SPRING / MASS);

	double tau_max;

	if (eta < 2.0 * omega0) {
		// Régimen subamortiguado (eta<2w_0)
		tau_max = (2.0 * MASS) / eta;
		double tau_osc = (2.0 * PI) / omega0;
		if (tau_osc > tau_max) {
			tau_max = tau_osc;
		}
	}
	else {
		// Régimen sobreamortiguado (eta>2.0)
		double discriminante = ((eta * eta) / (4.0 * MASS * MASS)) - (omega0 * omega0);
		if (discriminante < 0.0) discriminante = 0.0;
		double lambda_lento = (eta / (2.0 * MASS)) - sqrt(discriminante);
		tau_max = 1.0 / lambda_lento;
	}

	// Calculamos el tiempo físico de termalización
	double t_termalizacion = 50.0 * tau_max;

	// Si nos pasaron un puntero válido, guardamos el valor
	*t_term = t_termalizacion;

	return (long long)(t_termalizacion / h);
}

// Termalización del sistema
double thermalization(Particle1D* part, double eta, double h, int flag) {
	double t_term;
	// Calculamos el número de pasos necesario para termalizar y el tiempo de termalización.
	long long N_therm = thermalization_steps(eta, h, &t_term);

	// Bucle de termalización.
	switch (flag) {
	case 0:
		for (long long i = 0; i < N_therm; i++) step_euler_maruyama(part, eta, h);
		break;
	case 1:
		for (long long i = 0; i < N_therm; i++) step_runge_kutta2(part, eta, h);
		break;
	case 2:
		for (long long i = 0; i < N_therm; i++) step_verlet_gjf(part, eta, h);
		break;
	default:
		//Si fallamos al poner 0,1,2.
		break;
	}
	// Devolvemos el tiempo de termalización para que no se ejecuten esas medidas
	return t_term;
}
// Termalización del sistema usando verlet para el segundo sistema
void thermalization2(Particle1D* part, double eta, double h, double A) {
	// Calculamos el número de pasos necesario para termalizar.
	double t_term;
	long long N_therm = thermalization_steps(eta, h, &t_term);
	// Bucle de termalización.
	for (int i = 0; i < N_therm; i++) step_verlet_gjf2(part, eta, h, A);
}

//Teorema de la equipartición
void equipartition(Particle1D* part, double t_final, double h, double eta, const char* file, double t_term) {
	double t = t_term;
	double sum_T = 0.0;
	double sum_Ep = 0.0;
	long long n_pasos = 0;
	double Ep_inst;
	double T_inst;
	double Ep_prom;
	double T_prom;
	double t_sim = t_final + t_term;

	FILE* g = fopen(file, "w");
	if (!g) {
		printf("Error al abrir el archivo: %s\n", file);
		return;
	}

	// Guardar cada 0.5 unidades de tiempo
	// Si h = 1e-4, guarda cada 5000 pasos
	// Si h = 1e-1, guarda cada 5 pasos
	long long pasos_entre_guardados = (long long)(0.5 / h);
	if (pasos_entre_guardados < 1) pasos_entre_guardados = 1;

	while (t < t_sim) {
		n_pasos++;

		Ep_inst = 0.5 * K_SPRING * part->x * part->x;
		T_inst = (part->p * part->p) / (2.0 * MASS);

		sum_Ep += Ep_inst;
		sum_T += T_inst;

		Ep_prom = sum_Ep / n_pasos;
		T_prom = sum_T / n_pasos;

		// Guardar solo cuando toque
		if (n_pasos % pasos_entre_guardados == 0) {
			fprintf(g, "%f %f %f %f %f\n", Ep_prom, T_prom, t, part->x, part->p);
		}

		switch (FLAG) {
		case 0:
			step_euler_maruyama(part, eta, h);
			break;
		case 1:
			step_runge_kutta2(part, eta, h);
			break;
		case 2:
			step_verlet_gjf(part, eta, h);
			break;
		default:
			break;
		}
		t += h;
	}
	fclose(g);
}

void equipartition2(Particle1D* part, double t_final, double h, double eta, double A, const char* file) {
	// 1. Inicialización de variables
	double t = 0.0;
	double sum_T = 0.0;
	double sum_Ep = 0.0;
	long long n_pasos = 0;

	double Ep_inst, T_inst;
	double Ep_prom, T_prom;

	// 2. Control de dónde esta la particula.
	long long count_pos = 0;
	long long count_neg = 0;

	int estado_actual;
	if (part->x >= 0.0) {
		estado_actual = 1;   // Pozo derecho (x >= 0)
	}
	else {
		estado_actual = -1;  // Pozo izquierdo (x < 0)
	}

	double t_estancia = 0.0;

	// Algoritmo para guardar pasos (igual que en equipartition)
	long long pasos_entre_guardados = (long long)(0.5 / h);
	if (pasos_entre_guardados < 1) {
		pasos_entre_guardados = 1;
	}

	// Apertura del archivo de resultados
	FILE* g = fopen(file, "w");
	if (!g) {
		printf("Error al abrir el archivo: %s\n", file);
		return;
	}

	// Archivo auxiliar para registrar los tiempos de salto entre pozos
	char file_tiempos[256];
	sprintf(file_tiempos, "%s_tiempos.dat", file);
	FILE* f_t = fopen(file_tiempos, "w");

	// Archivo auxiliar para registrar las probabilidades de ocupación
	char file_ocupacion[256];
	sprintf(file_ocupacion, "%s_ocupacion.dat", file);
	FILE* f_o = fopen(file_ocupacion, "w");

	// 3. Bucle de evolución temporal
	while (t < t_final) {
		n_pasos++;

		// Energía potencial del doble pozo: V(x) = A * (x^2 - 1)^2
		double x2_menos1 = (part->x * part->x) - 1.0;
		Ep_inst = A * x2_menos1 * x2_menos1;

		// Energía cinética: T = p^2 / (2m)
		T_inst = (part->p * part->p) / (2.0 * MASS);

		sum_Ep += Ep_inst;
		sum_T += T_inst;

		Ep_prom = sum_Ep / (double)n_pasos;
		T_prom = sum_T / (double)n_pasos;

		// Conteo de ocupación de estados
		if (part->x >= 0.0) {
			count_pos++;
		}
		else {
			count_neg++;
		}

		// Detección de saltos entre pozos
		int estado_nuevo=estado_actual;
		if (part->x >= 0.5) {
			estado_nuevo = 1;
		}
		else {
			if (part->x <= -0.5)
			estado_nuevo = -1;
		}

		if (estado_nuevo != estado_actual) {
			// Si cambia de estado, anotamos donde ha saltado, y el tiempo que ha tardado en saltar.
			if (t_estancia > 0.0) {
				fprintf(f_t, "%f %d\n", t_estancia, estado_actual);
			}
			estado_actual = estado_nuevo;
			t_estancia = 0.0;
		}
		else {
			t_estancia += h;
		}

		// Guardar solo cuando toque
		if (n_pasos % pasos_entre_guardados == 0) {
			fprintf(g, "%f %f %f %f %f\n", Ep_prom, T_prom, t, part->x, part->p);
		}

		// Paso de simulación
		step_verlet_gjf2(part, eta, h, A);
		t += h;
	}


	fclose(g);
	fclose(f_t);

	// Guarda en el fichero las fracciones de ocupación calculadas (P(x>0) y P(x<0))
	double frac_pos = (double)count_pos / (double)n_pasos;
	double frac_neg = (double)count_neg / (double)n_pasos;
	fprintf(f_o, "%f %f", frac_pos, frac_neg); 	
	fclose(f_o);
}