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
	//Inicializamos las variables
	double t = 0;
	double sum_T = 0;
	double sum_Ep = 0;
	double n_pasos = 0;
	double Ep_inst;
	double T_inst;
	double Ep_prom;
	double T_prom;
	int contador = 0;
	//Abrimos archivos para guardar las energías
	FILE* g = fopen(file, "w");
	if (!g) {
		printf("Error al abrir el archivo\n");
		return;
	}
	// Simulamos pasos, y vamos guardando el promedio de la energía potencial y cinética, asi como posicion y momento de la particula.
	while (t < t_final) {
		
		n_pasos++;
		Ep_inst = A * (part->x * part->x - 1)*(part->x * part->x - 1);
		T_inst = (part->p * part->p) / (2.0 * MASS);
		sum_Ep += Ep_inst;
		sum_T += T_inst;
		Ep_prom = sum_Ep / n_pasos;  //Promedio de la energía potencial.
		T_prom = sum_T / n_pasos; //Promedio de la energía cinética.

		fprintf(g, "%f %f %f %f %f\n", Ep_prom, T_prom, t, part->x, part->p);
		step_verlet_gjf(part, eta, h);
		t += h;
	}
	fclose(g);
}