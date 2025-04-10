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

array [1..6, 1..5] of int: aceiteTotal;  %el aceite total que tenemos este mes (antes de refinar)
array [1..6, 1..5] of int: aceiteComprado;  %el aceite comprado este mes (solo para facilitar cálculos)
array [1..6, 1..5] of 0..max(MAXV, MAXN): cuantoRefinar;  %el aceite total que refinamos este mes

%cálculos de aceite comprado
constraint forall(a in 1..5)(aceiteComprado[1,a] = inicial[a]- aceiteTotal[1,a]);  %el primer mes
constraint forall(m in 2..6, a in 1..5)(aceiteComprado[m,a] = aceiteTotal[m-1, a] - aceiteTotal[m, a]);

%no almacenar mas aceite vegetal del que podemos
constraint forall(m in 1..6, a in 1..5)(aceiteTotal[m,a] <= MCAP);

%no desviarnos de PV al final
constraint forall(a in 1..5)(abs(inicial[a] - (aceiteTotal[6,a] - cuantoRefinar[6,a]))/inicial[a] * 100 <= PV);

%no refinar más aceite del que tenemos
constraint forall(m in 1..6, a in 1..5)(cuantoRefinar[m,a] <= aceiteTotal[m,a]);  %refinar aceite vegetal
%no refinar más aceite vegetal del que podemos
constraint forall(m in 1..6)(cuantoRefinar[m,1] + cuantoRefinar[m,2] <= MAXV);
%no refinar mas aceite no vegetal del que podemos
constraint forall(m in 1..6)(cuantoRefinar[m,3] + cuantoRefinar[m,4] + cuantoRefinar[m,5] <= MAXN);

%calcular beneficios finales
constraint sum(m in 1..6, a in 1..5)(cuantoRefinar[m,a]*VALOR - aceiteComprado[m,a]*precios[m,a]) >= minB;