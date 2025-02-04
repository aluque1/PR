int: numeroJuguetes = 4;
int: numeroNinos = 3;
array[1..numeroJuguetes] of int : disp = [2, 1, 1, 2];
array [1..numeroJuguetes] of int: tiposDeJug = [1, 1, 2, 3];
array  [1..numeroNinos, 1..numeroJuguetes] of int: satisfc = [|8,9,3,1
                                                              |6,4,5,3
                                                              |2,2,9,9|];

array[1..numeroNinos, 0..1] of var int: sol;

%los regalos son diferentes
constraint forall(x in 1..numeroNinos)(tiposDeJug[sol[x, 0]] != tiposDeJug[sol[x, 1]]);

%no tenemos mas juguetes de los q deberiamos
constraint forall(x in 1..numeroJuguetes)((sum(n in 1..numeroNinos, j in 0..1 where sol[n,j] = x)(1)) <= disp[x]);

%los regalos suman satisfacción positiva;
solve maximize (sum(x in 1..numeroNinos)(satisfc[x,sol[x,0]] + satisfc[x,sol[x,1]]));
