#include "integrators.h"
#include "random.h"
#include "simulacion.h"

int FLAG = 0;

// Núcleo del programa
int main(void) {
	init_random();
	int i, j;

	double etas[] = {0.1, 1.0, 10.0};
	double hs[] = {1e-4, 1e-3, 1e-2, 1e-1};
	double t_final = 1000.0;

	char filename[100];
	Particle1D part;

	for(FLAG = 0; FLAG < 3; FLAG++){ //Recorro las flags
		for(i = 0; i < 3; i++){ //Recorro las etas
			for(j = 0; j < 4; j++){ //Recorro las hs
				double eta = etas[i];
				double h = hs[j];

				//Reiniciamos particula
				part.x = 0.0;
				part.p = 0.0;

				//Termalizamos (descartamos)
				thermalization(&part, eta, h);

				//Nombre archivo unico simulacion
				sprintf(filename, "resultados/data_alg%d_eta%.1f_h%.4f.dat", FLAG, eta, h);

				//Ejecutar la medida
				equipartition(&part, t_final, h, eta, filename);

				printf("Simulacion completada con algortmo %d eta=%.1f h=%.4f\n", FLAG, eta, h);
			}
		}
	}
	return 0;
}