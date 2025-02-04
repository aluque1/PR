int: num_jug = 4;

int: num_ninos = 3;

array[1..num_jug] of int: disp = [2, 1, 1, 2];

array[1..num_jug] of int: tipo_jug = [1, 1, 2, 3];

array[1..num_ninos, 1..num_jug] of int : satis = [| 8, 9, 3, 1

                                                  | 6, 4, 5, 3

                                                  | 2, 2, 9, 9 |];


array[1..num_ninos, 0..1] of var int : sol;


% No repetirmos tipo e regale en los ninios

constraint forall(x in 1..num_ninos)(tipo_jug[sol[x, 0]] != tipo_jug[sol[x, 1]]);


% No repartimos mas jugetes de los disponibles

constraint forall(x in 1..num_jug) ((sum(i in 0..num_ninos, j in 0..1 where sol[i,j] = x)(1)) <= disp[x]);


solve maximize (sum(x in 1..num_ninos) (satis[x, sol[x,0]] + satis[x, sol[x,1]]));
