#include "simulacion.h"
#include "integrators.h"
#include "stdio.h"


// Obtiene los pasos de termalización.
int thermalization_steps(double eta, double h) {
	// Tiempos característicos: oscilación (tau_osc), relajación viscosa (tau_visc) y difusión sobreamortiguada (tau_sobre).
		double tau_osc = (2.0 * PI) / (sqrt(K_SPRING / MASS));
		double tau_visc = 1.0 / eta;
		double tau_sobre = (eta * MASS) / K_SPRING;

	// Identificar el regimen que domina el sistema.
		double tau_max = tau_visc; 
		if (tau_osc > tau_max) tau_max = tau_osc;
		if (tau_sobre > tau_max) tau_max = tau_sobre;

	// Un tiempo característico aproximado de 5*tau_max será suficiente para que el sistema termalice.
		tau_max *= 5.0;

	// Calculamos los pasos necesarios:
		return (int)(tau_max / h);
}

// Termalización del sistema
void thermalization(Particle1D* part, double eta, double h, double *xhist, double *phist) {
	// Calculamos el número de pasos necesario para termalizar.
	int N_therm = thermalization_steps(eta, h);

	// Bucle de termalización.
	switch (FLAG) {
	case 0:
		for (int i = 0; i < N_therm; i++) step_euler_maruyama(part, eta, h, xhist, phist);
		break;
	case 1:
		for (int i = 0; i < N_therm; i++) step_runge_kutta2(part, eta, h, xhist, phist);
		break;
	case 2:
		for (int i = 0; i < N_therm; i++) step_verlet_gjf(part, eta, h, xhist, phist);
		break;
	default:
		//Si fallamos al poner 0,1,2.
		break;
	}
}

//Teorema de la equipartición
void equipartition( Particle1D *part, double t_final, double h, double eta, const char* file) {
	//Inicializamos las variables
	double t = 0;
	double sum_T = 0;
	double sum_Ep = 0;
	double n_pasos = 0;
	double Ep_inst;
	double T_inst;
	double Ep_prom;
	double T_prom;
	//Abrimos archivos para guardar las energías
	FILE* g = fopen(file, "w");
	if (!g) {
		printf("Error al abrir el archivo\n");
		return;
	}
	// Simulamos pasos, y vamos guardando el promedio de la energía potencial y cinética.
	while (t < t_final) {
		n_pasos++;
		Ep_inst = 0.5 * K_SPRING * part->x * part->x;
		T_inst = (part->p * part->p) / (2.0 * MASS);
		sum_Ep += Ep_inst;
		sum_T += T_inst;
		Ep_prom = sum_Ep / n_pasos;  //Promedio de la energía potencial.
		T_prom = sum_T / n_pasos; //Promedio de la energía cinética.
		fprintf(g, "%f %f %f %f %f\n", Ep_prom, T_prom, t, part->x, part->p);
		//Paso de simulación
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
			//Si fallamos al poner 0,1,2.
			break;
		}
		t += h;
	}
	fclose(g);

	}