#Clase que guarda los metodos de un estado
class Estado:
	numero = 0
	inicial = False
	final = False

	def __init__(self,numero,inicial,final):
		self.numero = numero
		self.inicial = inicial
		self.final = final
		self.transiciones = []

	def agregar_transicion(self,simbolo,siguiente):
		temp = [simbolo,siguiente]
		self.transiciones.append(temp)

	def siguiente(self,simbolo):
		i = 0
		for i in range(0,len(self.transiciones)):
			if self.transiciones[i][0] == simbolo:
				estado = self.transiciones[i][1]
		return estado
		 
#Reggresa la posicion de un elemento en un arreglo de nodos
def posicion(nodos,elemento):
	i = 0
	posicion = -1
	for i in range(0,len(nodos)):
		if nodos[i].numero == int(elemento):
			posicion = i
	return posicion

#Crea tuplas que guardan las transiciones del archivo
def tres(transiciones):
	temp = []
	anterior = 0
	for i in range(0,len(transiciones)/3):
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

f = open('automata.txt','r')
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

print estados
print simbolos

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
for i in range(0,len(nodos)):
	if nodos[i].inicial:
		print("El estado "+str(nodos[i].numero)+" es un estado inicial")
	if nodos[i].final:
		print("El estado "+str(nodos[i].numero)+" es un estado final")


i = 0
for i in range(0,len(transiciones)):
	temp = posicion(nodos,transiciones[i][0])
	if temp != -1:
		temp2 = posicion(nodos,transiciones[i][2])
		if temp2 != -1:
			nodos[temp].agregar_transicion(transiciones[i][1],temp2)

i = 0
for i  in range(0,len(nodos)):
	print nodos[i].numero
	print nodos[i].transiciones

print nodos[0].siguiente('a')
