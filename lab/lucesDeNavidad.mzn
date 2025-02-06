int: longitud = 5;
int: nColores = 3;
int: consumoMaximo = 7;
array[1..nColores] of int: consumo = [2,1,3];

array[1..longitud] of var 1..nColores: tira;

constraint forall(x in 1..longitud-2)(tira[x] != tira[x+1] \/ tira[x] != tira[x+2]);
constraint sum(x in 1..longitud)(consumo[tira[x]]) <= consumoMaximo;

%ahora lo dificl
constraint forall(x in 1..longitud)(forall(y in 1..nColores)(((sum(z in 1..x where tira[z] = y)(1))>=((x-1)/nColores) -1)));