%aceites totales: 5. aceites vegetales 1,2. aceites no vegetales: 3, 4, 5
int: VALOR;  %por cuanto vendemos el aceite
int: MAXV;  %cuando aceite vegetal podemos refinar como máximo
int: MAXN;   %cuanto aceite no vegetal podemos refinar como máximo
int: MCAP;  %cuanto aceite de cada tipo podemos almacenar
int: CA; %coste de almacenamiento de los aceites. Los aceites refinados no pueden almacenarse
array [1..5] of int: dureza;
int: minD; %dureza minima del aceite no vegatal
int: maxD;  %dureza máxima del aceite no vegetal 
array [1..5, 1..6] of int: precios;
array [1..5] of int: inicial;  %aceites con los que empezamos
int: PV;  %porcentaje de desviación con los aceites iniciales
int: minB;   %beneficio mínimo

array [1..6, 1..5] of 0..MCAP: cuantoComprar;
array [1..6, 1..2] of 0..max(MAXV, MAXN): cuantoRefinar;