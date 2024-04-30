Sets
  i Periodos / mar16, apr16, may16, jun16, jul16, aug16, sep16, oct16, nov16, dec16 /
*Define el conjunto de períodos (marzo a diciembre de 2016) *
  l Niveles / 1, 2, 3, 4 /;
*Define el conjunto de los 4 niveles de la red de distribución *;

Parameters
  B(i) Capacidad máxima de producción en el periodo i
*Parametro que contiene la capacidad máxima de producción para cada período *

 D(i) Demanda de GNV en el periodo i
*Parametro que contiene la demanda proyectada de GNV para cada período *

 H(i,l) Costo de mantener inventario en el nivel l durante el periodo i
*Parametro con el costo de mantener inventario en cada nivel y período *

 C(i,l) Costo de transporte del nivel l al nivel l+1 en el periodo i
*Parametro con el costo de transporte entre niveles consecutivos para cada período *

 P(i) Costo de producción en el periodo i
*Parametro con el costo de producción en cada período *

 M "Grande valor para penalización" / 100000 /;
*representa un valor grande para penalizar el incumplimiento de demanda *;

B('mar16') = 707.51;
B('apr16') = 697.86;
B('may16') = 698.62;
B('jun16') = 597.21;
B('jul16') = 289.58;
B('aug16') = 691.66;
B('sep16') = 689.15;
B('oct16') = 405.84;
B('nov16') = 900.70;
B('dec16') = 901.68;

D('mar16') = 513.12;
D('apr16') = 331.21;
D('may16') = 197.14;
D('jun16') = 389.08;
D('jul16') = 470.98;
D('aug16') = 526.17;
D('sep16') = 809.95;
D('oct16') = 964.22;
D('nov16') = 1009.77;
D('dec16') = 1211.72;

H('mar16',l) = 3;
H('apr16',l) = 3;
H('may16',l) = 3;
H('jun16',l) = 3;
H('jul16',l) = 3;
H('aug16',l) = 3;
H('sep16',l) = 3;
H('oct16',l) = 3;
H('nov16',l) = 3;
H('dec16',l) = 3;

C('mar16',l) = 1.5;
C('apr16',l) = 1.5;
C('may16',l) = 1.5;
C('jun16',l) = 1.5;
C('jul16',l) = 1.5;
C('aug16',l) = 1.8;
C('sep16',l) = 1.8;
C('oct16',l) = 1.8;
C('nov16',l) = 1.8;
C('dec16',l) = 1.8;

P('mar16') = 1;
P('apr16') = 1;
P('may16') = 1;
P('jun16') = 1;
P('jul16') = 1;
P('aug16') = 1.2;
P('sep16') = 1.2;
P('oct16') = 1.2;
P('nov16') = 1.2;
P('dec16') = 1.2;

Variables
  Y(i) Cantidad producida en el periodo i
*Variable de decisión para la cantidad a producir en cada período *

 X(i,l) Cantidad enviada del nivel l al nivel l+1 en el periodo i
*Variable de decisión para la cantidad a transportar entre niveles en cada período *

 A(i,l) Inventario en el nivel l al final del periodo i
*Variable de decisión para el nivel de inventario en cada nivel y período *

 Z Función objetivo que se desea minimizar
*Variable que representa el valor de la función objetivo a minimizar *

 Slack(i) Variable de holgura para la restricción de demanda;
*Variable de holgura que permite incumplir la demanda con una penalización *

Equations
  OBJ Función objetivo
*La función objetivo busca minimizar los costos de producción, transporte, inventario y penalización.
  CAP(i) Restricción de capacidad de producción
*Esta restricción asegura que la producción no exceda la capacidad máxima en cada período.
  DEMAND(i) Restricción de demanda
*Esta restricción garantiza que la demanda sea cubierta por los flujos de salida más la variable de holgura en cada período.
  BAL(i,l) Restricción de balance de inventario;
*Esta restricción asegura el balance de inventarios en cada nivel, con base en los flujos de entrada y salida.

OBJ..
  Z =E= SUM(i, Y(i)*P(i)) + SUM((i,l), X(i,l)*C(i,l)) + SUM((i,l), A(i,l)*H(i,l)) + SUM(i, Slack(i)*M);
*Definición de la función objetivo a minimizar, sumando los costos mencionados *

CAP(i)..
  Y(i) =L= B(i);
*Restricción que limita la producción a la capacidad máxima *

DEMAND(i)..
  SUM(l, X(i,l)) + Slack(i) =E= D(i);
*Restricción que obliga a satisfacer la demanda con los flujos de salida más holgura *

BAL(i,l)$(ord(l) < card(l))..
  A(i,l+1) =E= A(i,l) + X(i,l) - X(i,l-1);
*Restricción de balance, el inventario al siguiente nivel es el actual más entrada menos salida *

Y.LO(i) = 0;
X.LO(i,l) = 0;
A.LO(i,l) = 0;
Slack.LO(i) = 0;
*Establece la no negatividad de las variables de decisión *

Model TGIMODEL /all/;
*Declaración del modelo con todas las ecuaciones *
Solve TGIMODEL using LP minimizing Z;
*Indica que se debe resolver el modelo TGIMODEL como un problema de Programación Lineal minimizando Z *

