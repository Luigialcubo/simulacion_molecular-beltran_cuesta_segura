#include "integrators.h"
#include "random.h"
#include "simulacion.h"



// Núcleo del programa
int main(void) {
	init_random();
	correlacion_numeros_aleatorios("muestra_random_gauss_1.dat", 100000);
	return 0;
}