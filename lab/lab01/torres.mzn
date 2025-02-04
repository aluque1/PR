% Use this editor as a MiniZinc scratch book
enum colores = {azul, rojo, verde};
par int: altura;
array [0..altura-1] of var colores: torre;
array [colores] of int: disp;

altura = 10;
disp = [3,5,3];



%q no usemos mas piezas de las disponibles
constraint forall(c in colores)(sum(i in 0..altura-1)(bool2int(torre[i] = c)) <= disp[c]);

%q haya piezas verdes y azules en proporción y eso
constraint (sum(i in 0..altura-1 where torre[i] = rojo)(1)) >= altura/2;
constraint forall(x in 0..altura-2)(torre[x] != verde \/ torre[x+1] != verde);
constraint (sum(i in 0..altura-1 where torre[i] = verde)(1)) < (sum(i in 0..altura-1 where torre[i] = azul)(1));




constraint torre[0] = rojo;

