#include "../include/integrators.h"
#include "../include/random.h"
#include "../include/simulacion.h"

int FLAG = 0;

	// Núcleo del programa
int main(void) {
	init_random();
	char filename[100];
	Particle1D part;
	//int i, j;

	//double etas[] = { 0.1, 1.0, 10.0 };
	//double hs[] = { 1e-4, 1e-3, 1e-2, 1e-1 };
	//double t_final = 15000.0;
	//double t_term = 0;

	/*
	// Primer objetivo	
	for (FLAG = 0; FLAG < 3; FLAG++) { //Recorro las flags
		for (i = 0; i < 3; i++) { //Recorro las etas
			for (j = 0; j < 4; j++) { //Recorro las hs
				double eta = etas[i];
				double h = hs[j];

				//Reiniciamos particula
				part.x = 0.0;
				part.p = 0.0;

				//Termalizamos (descartamos)
				t_term = thermalization(&part, eta, h, FLAG);
				//Nombre archivo unico simulacion
				sprintf(filename, "resultados/data_alg%d_eta%.1f_h%.4f.dat", FLAG, eta, h);

				//Ejecutar la medida
				equipartition(&part, t_final, h, eta, filename, t_term);

				printf("Simulacion completada con algortmo %d eta=%.1f h=%.4f\n", FLAG, eta, h);
			}
		}
	}
	*/


	// Segundo objetivo
	FLAG = 2; // Verlet
	double h = 0.01;
	double t_final;

	double etas2[] = { 0.01, 0.1, 1.0, 5.0 };
	double A[] = { 0.5, 1.0, 2.0 };

	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 3; j++) {
			double eta = etas2[i];
			double A2 = A[j];

			// Partícula en el fondo del pozo derecho
			part.x = 1.0;
			part.p = 0.0;

			// Termalización
			long long pasos_termalizacion = 300000; // Pasos previos sin fprintf
			for (long long step = 0; step < pasos_termalizacion; step++) {
				// Llamas al paso de integración del doble pozo
				step_verlet_gjf2(&part, eta, h, A2);
			}

			// Nombre de archivo único que incluye eta y A
			sprintf(filename, "resultados/doblepozo_eta%.2f_A%.1f.dat", eta, A2);

			// Medida y simulación
			if(eta >= 0.1){
				if (A2 >= 2.0) {
					t_final = 1000000.0;  // Grande para que atraviese más la barrera
				}
				else {
					t_final = 600000.0;  
				}
			}
			else{
				t_final = 3000000.0; // Necesitamos más tiempo para las etas pequeñas para que podamos asegurar que el sistema ha termalizado.
			}
			equipartition2(&part, t_final, h, eta, A2, filename);

			printf("Simulacion completada eta=%.2f A=%.1f\n", eta, A2);
		}
	}
	return 0;
}