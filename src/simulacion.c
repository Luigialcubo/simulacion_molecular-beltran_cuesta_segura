#include "simulacion.h"
#include "integrators.h"


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
	double Ep=0;
	double T=0;
	double Ep_media;
	double T_media;
	//Calculamos la energía cinética y potencial.
	for(int i = 0; i < N_therm; i++){
		Ep+=(K_SPRING*part->x*part->x)/2.0;
		T+=(part->p*part->p)/(2.0*MASS);
	}
	// Comprobamos el teorema de la equipartición de energía
	Ep_media = Ep / N_therm;
	T_media = T / N_therm;
	printf("Ep_media= ", "%f\n", Ep_media);
	printf("T_media= ", "%f\n", T_media);
}