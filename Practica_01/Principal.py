from C_automata import *
import Verificar

# Convierte la linea que se mande de un archivo en una lista
def leer(last_line):
    automata = open("Archivo.txt","r")
    datos_final=[]
    transiciones=[]

    count = len(open("Archivo.txt").readlines(  ))
    for i in range(4):
        automata.seek(last_line)
        cadena = automata.readline()
        datos = cadena.split(",")
        aux = datos.pop()
        aux = aux.rstrip('\n')
        datos.append(aux)
        last_line = automata.tell()
        datos_final.append(datos)
    
    for i in range(count-4):
        automata.seek(last_line)
        cadena = automata.readline()
        datos = cadena.split(",")
        aux = datos.pop()
        aux = aux.rstrip('\n')
        datos.append(aux)
        last_line = automata.tell()
        transiciones.append(datos)
    datos_final.append(transiciones)
    return (datos_final)
    
datos_proscesados = leer(0)
estados = datos_proscesados[0]
estados.append(-1)
estados = tuple(map(int,estados))
simbolos =tuple(datos_proscesados[1])
inicial =tuple(map(int,datos_proscesados[2]))
final = tuple(map(int,datos_proscesados[3]))
transiciones = tuple(datos_proscesados[4])

if len(inicial) > 1:
	print("\033[1;31m"+"ERROR"+"\033[0;m"+"\nSolo puede haber un estado inicial")
	exit()
#Creacion de los objetos estado
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
	Verificar.recorre(nodos,simbolos,posicion(nodos,inicial[0]),cadena,[],cadena,validos)
	if len(validos) == 0:
		print("\033[1;31m"+"Cadena no valida"+"\033[0;m")
