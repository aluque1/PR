int : nCanciones = 2;
int : vIda = 10;
int : vVuelta = 10;

array[1..nCanciones, 1..2] of int : infoCanciones = [|10, 7|15, 4|];

array[1..nCanciones] of var 0..2 : cancionesSelec;

constraint (sum (x in 1..nCanciones where cancionesSelec[x] = 1)(infoCanciones[x, 1])) = vIda;
constraint (sum (x in 1..nCanciones where cancionesSelec[x] = 2)(infoCanciones[x, 1])) = vVuelta;

solve maximize (sum (x in 1..nCanciones where cancionesSelec[x] != 0)(infoCanciones[x, 2]));