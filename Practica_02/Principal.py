from Automata import *
from Verificar import *
#Crea tuplas que guardan las transiciones del archivo
def tres(transiciones):
	temp = []
	anterior = 0
	for i in range(0,int(len(transiciones)/3)):
		siguiente = (i+1)*3
		temp.append(transiciones[anterior:siguiente])
		anterior  = siguiente
	return temp

#Convierte todas las cadenas de una lista en enteros
def convertir(cadena):
	temp = []
	for i in range(0,len(cadena)):
		temp.append(int(cadena[i]))
	return temp

#Crea lista basada en una cadena
def get_elementos(cadena):
	i = 0
	j = 0
	elementos = []
	while i <= len(cadena):
		if  i == len(cadena) or cadena[i] == ',' or cadena[i] == '\n':
			elementos.append(cadena[j:i])
			i += 1
			j = i
		i+=1
	return elementos

#Crea una nueva linea, usando como delimitador un salto de linea
def get_linea(inicial,cadena):
	i = inicial
	while cadena[i] != '\n':
		i += 1
	return cadena[inicial:i]

f = open('input','r')
contenido = f.read()

i = 0
estados = get_linea(i,contenido)
i += (len(estados) + 1)
simbolos = get_linea(i,contenido)
i += (len(simbolos) + 1)
inicial = get_linea(i,contenido)
i += (len(inicial) + 1)
final = get_linea(i,contenido)
i += (len(final) + 1)
transiciones = contenido[i:len(contenido)]

estados = convertir(get_elementos(estados))
simbolos = tuple(get_elementos(simbolos))
inicial = tuple(convertir(get_elementos(inicial)))
final = tuple(convertir(get_elementos(final)))
transiciones = tuple(tres(get_elementos(transiciones)))
estados.append(-1)
estados = tuple(estados)

if len(inicial) > 1:
	print("\033[1;31m"+"ERROR"+"\033[0;m"+"\nSolo puede haber un estado inicial")
	exit()

nodos = []
i = 0
for i in range(0,len(estados)):
	primero = False
	ultimo = False
	if estados[i] in inicial:
		primero = True
	if estados[i] in final:
		ultimo = True
	nodos.append(Estado(estados[i],primero,ultimo))

i = 0
for i in range(0,len(transiciones)):
	temp = posicion(nodos,transiciones[i][0])
	if temp != -1:
		temp2 = posicion(nodos,transiciones[i][2])
		if temp2 != -1:
			nodos[temp].agregar_transicion(transiciones[i][1],temp2)

i = 0
for i in range(0,len(nodos)):
	temp = completar(simbolos,simbolos_transitivos(nodos[i],simbolos))
	j = 0
	for j in range(0,len(temp)):
		nodos[i].agregar_transicion(temp[j],estados.index(-1))
imprimir_tabla(nodos,simbolos)

while True:
	cadena = input("Ingrese la cadena que desea validar: ")
	i = 0
	validos = []
	recorre(nodos,simbolos,posicion(nodos,inicial[0]),cadena,[],cadena,validos)
	if len(validos) == 0:
		print("\033[1;31m"+"Cadena no valida"+"\033[0;m")
	# print(validos)