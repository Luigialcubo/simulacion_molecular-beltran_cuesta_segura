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
	double t_final = 10000.0;

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
				thermalization(&part, eta, h, FLAG);
				printf("Estado tras termalizar: x = %e, p = %e\n", part.x, part.p);
				//Nombre archivo unico simulacion
				sprintf(filename, "resultados/data_alg%d_eta%.1f_h%.4f.dat", FLAG, eta, h);

				//Ejecutar la medida
				equipartition(&part, t_final, h, eta, filename);

				printf("Simulacion completada con algortmo %d eta=%.1f h=%.4f\n", FLAG, eta, h);
			}
		}
	}



//Segundo objetivo.
FLAG=2; //Escogemos Verlet y h=10^-3.
double etas2[]={0.01, 0.1, 1.0, 5.0};
double A[]={0.5, 1, 2};
	for(i = 0; i < 4; i++){ //Recorro las etas
			for(j = 0; j < 3; j++){ //Recorro las A
				double eta = etas2[i];
				double A2 = A[j];

				//Reiniciamos particula
				part.x = 0.0;
				part.p = 0.0;

				//Termalizamos (descartamos)
				thermalization2(&part, eta, 0.001, A2);
				printf("Estado tras termalizar: x = %e, p = %e\n", part.x, part.p);
				//Nombre archivo unico simulacion
				sprintf(filename, "resultados/data_alg%d_eta%.1f_h%.4f.dat", FLAG, eta, 0.001);

				//Ejecutar la medida
				equipartition2(&part, t_final, 0.001, eta, A2, filename);

				printf("Simulacion completada eta=%.1f A=%.1f\n", eta, A2);
			}
		}
	
	return 0;
}