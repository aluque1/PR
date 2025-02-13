int : nCanciones = 6;
int : vIda = 20;
int : vVuelta = 15;

array[1..nCanciones, 1..2] of int : infoCanciones = [|5, 7|3, 10|10, 8|5,6|8, 8| 7, 6|];

array[1..nCanciones] of var 0..1 : cancionesIda;
array[1..nCanciones] of var 0..1 : cancionesVuelta;

constraint (sum (x in 1..nCanciones)(infoCanciones[x, 1]* cancionesIda[x])) = vIda;
constraint (sum (x in 1..nCanciones)(infoCanciones[x, 1] * cancionesVuelta[x])) = vVuelta;
constraint forall(x in 1..nCanciones)(cancionesIda[x] * cancionesVuelta[x] = 0);

solve maximize (sum (x in 1..nCanciones)(infoCanciones[x, 2] *cancionesVuelta[x]) + sum (x in 1..nCanciones)(infoCanciones[x, 2] *cancionesIda[x]));