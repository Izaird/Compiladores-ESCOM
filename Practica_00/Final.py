from Automata import *
import Thompson

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

f = open('Archivo.txt','r')
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
simbolos = get_elementos(simbolos)
inicial = convertir(get_elementos(inicial))
final = convertir(get_elementos(final))
transiciones = tres(get_elementos(transiciones))
estados.append(-1)

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

Nuevos_estados = []
estados_alcanzables = [str(estados[inicial[0]])]
estados_alcanzables += Thompson.Cerradura_E(transiciones,str(estados[inicial[0]]))
Nuevos_estados.append(Thompson.Estado_AFD('A',estados_alcanzables,0))

bandera = 1
while bandera != 0:
	bandera = 0
	i = 0
	for i in range(0,len(Nuevos_estados)):
		j = 0
		for j in range(0,len(simbolos)):
			estados_alcanzables = Thompson.Ir_a(transiciones,simbolos[j],Nuevos_estados[i])
			if Thompson.analisis(Nuevos_estados,estados_alcanzables):
				letra = chr(ord(Nuevos_estados[len(Nuevos_estados) - 1].simbolo) + 1)
				if Thompson.final(final,estados_alcanzables,estados):
					Nuevos_estados.append(Thompson.Estado_AFD(letra,estados_alcanzables,2))
				else:	
					Nuevos_estados.append(Thompson.Estado_AFD(letra,estados_alcanzables,1))
				bandera += 1

N_trancisiones = Thompson.crear_trancisiones(Nuevos_estados,transiciones,simbolos)
N_final = []
N_estados = []

i = 0
for i in range(0,len(Nuevos_estados)):
	if Nuevos_estados[i].inicial:
		N_inicial = [i]
	if Nuevos_estados[i].final:
		N_final += [i]
	N_estados += [Nuevos_estados[i].simbolo]
Nuevos_estados.append(Thompson.Estado_AFD("-1",[],1))
N_estados.append("-1")

i = 0
for i in range(0,len(N_trancisiones)):
	temp = Thompson.posicion(Nuevos_estados,N_trancisiones[i][0])
	if temp != -1:
		temp2 = Thompson.posicion(Nuevos_estados,N_trancisiones[i][2])
		if temp2 != -1:
			Nuevos_estados[temp].agregar_transicion(N_trancisiones[i][1],temp2)


i = 0
for i in range(0,len(Nuevos_estados)):
	temp = Thompson.completar(simbolos,Thompson.simbolos_transitivos(Nuevos_estados[i],simbolos))
	j = 0
	for j in range(0,len(temp)):
		Nuevos_estados[i].agregar_transicion(temp[j],N_estados.index("-1"))
Thompson.imprimir_tabla_nueva(Nuevos_estados,simbolos)

