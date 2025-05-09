#!/usr/bin/python3
import z3
from z3 import *
import sys

filenameIn = sys.argv[1]
myinput = "".join(open(filenameIn, "r").readlines())
sys.stdin = io.StringIO(myinput)

# reading parameters:
VALOR = int(input()) #por cuanto vendemos el aceite
dureza = []
aux = input().split()
for i in range(0,5):
    dureza.append(float(aux[i]))

precios = []
for i in range(0,6):
    tpre = input().split()
    lpre = []
    for j in range(0,5):
        lpre.append(int(tpre[j]))
    precios.append(lpre) # Esto lo cambio porque no tenemos como tan algo que se llame coefs

MAXV = int(input())     #cuando aceite vegetal podemos refinar como máximo
MAXN = int(input())     #cuanto aceite no vegetal podemos refinar como máximo
MCAP = int(input())     #cuanto aceite de cada tipo podemos almacenar
CA = int(input())       #coste de almacenamiento de los aceites. Los aceites refinados no pueden almacenarse
MinD = float(input())   #dureza minima del a2ceite no vegatal
MaxD = float(input())   #dureza máxima del aceite no vegatal
MinB = int(input())     #beneficio mínimo

inicial = []    #aceites con los que empezamos
aux = input().split()
for i in range(0,5):
    inicial.append(int(aux[i]))

PV = float(input()) #porcentaje de desviación con los aceites con los q empezamos

# end of parameters


#funciones auxiliares
def n_equis(i):
    return "x_"+str(i)

def abs(x):
    return If(x >= 0,x,-x)

#fin de las definiciones


s = SolverFor("QF_LIA")


# Definicion de variables de la solucion
a = 0
aceiteTotal = []        #aceite que tenemos este mes, antes de refinar. matriz 6x5
for i in range(0, 6):
    aux = []
    for j in range (0, 5):
        aux.append(Int(n_equis(a)))
        a+=1
    aceiteTotal.append(aux)

aceiteComprado = []     #aceite que compramos este mes. matriz 6x5
for i in range(0, 6):
    aux = []
    for j in range (0, 5):
        aux.append(Int(n_equis(a)))
        a+=1
    aceiteComprado.append(aux)

cuantoRefinar = []    #aceite que refinamos este mes. matriz 6x5
for i in range(0, 6):
    aux = []
    for j in range (0, 5):
        aux.append(Int(n_equis(a)))
        a+=1
    cuantoRefinar.append(aux)
# Fin definicion


#CONSTRAINTS

#cálculos de aceite comprado (por coherencia)
#constraint forall(a in 1..5)(aceiteTotal[1,a] = inicial[a] + aceiteComprado[1,a]);  %el primer mes
for i in range(0, 5):
    s.add(aceiteTotal[0][i] == (inicial[i] + aceiteComprado[0][i]))
#constraint forall(m in 2..6, a in 1..5)(aceiteTotal[m,a] = aceiteTotal[m-1, a] - cuantoRefinar[m-1,a] + aceiteComprado[m, a]);  %el resto
for j in range(1, 6):
    for i in range(0, 5):
        s.add(aceiteTotal[j][i] == (aceiteTotal[j-1][i] - cuantoRefinar[j-1][i] + aceiteComprado[j][i]))

#no almacenar mas aceite del que podemos
#constraint forall(m in 1..6, a in 1..5)(aceiteTotal[m,a] - cuantoRefinar[m,a] <= MCAP);
for j in range(0, 6):
    for i in range(0, 5):
        s.add((aceiteTotal[j][i] - cuantoRefinar[j-1][i]) <= MCAP)

#no desviarnos de PV al final
#constraint forall(a in 1..5)(int2float(abs((inicial[a] - (aceiteTotal[6, a] - cuantoRefinar[6,a]))))/int2float(inicial[a]) * 100 <= PV);
for i in range(0,5):
    s.add((abs(inicial[i] - aceiteTotal[5][i] + cuantoRefinar[5][i])/inicial[i] * 100) <= PV)

#no refinar más aceite del que tenemos
#constraint forall(m in 1..6, a in 1..5)(cuantoRefinar[m,a] <= aceiteTotal[m,a]);
for j in range(0, 6):
    for i in range(0, 5):
        s.add(cuantoRefinar[j][i] <= aceiteTotal[j][i])

#no refinar más aceite vegetal del que podemos
#constraint forall(m in 1..6)(cuantoRefinar[m,1] + cuantoRefinar[m,2] <= MAXV);
for j in range(0, 6):
    s.add((cuantoRefinar[j][0] + cuantoRefinar[j][1]) <= MAXV)

#no refinar mas aceite no vegetal del que podemos
#constraint forall(m in 1..6)(cuantoRefinar[m,3] + cuantoRefinar[m,4] + cuantoRefinar[m,5] <= MAXN);
for j in range(0, 6):
    s.add((cuantoRefinar[j][2] + cuantoRefinar[j][3]+ cuantoRefinar[j][4]) <= MAXN)


#FIN DE CONSTRAINTS

print(s.check())

if s.check() == z3.sat:
    print(s.model().eval(equises[i]))
else:
    print("No hay solución")
    exit(0)

