class Estado_AFD:
	estados = []
	simbolo = '0'
	inicial = False
	normal = False
	final = False


	def __init__(self,simbolo,estados,tipo):
		self.simbolo = simbolo
		self.estados = estados
		self.transiciones = []
		if tipo == 0:
			self.inicial = True
		if tipo == 1:
			self.normal = True
		if tipo == 2:
			self.final = True

	def siguiente(self,simbolo,nodos):
		i = 0
		estado = []
		for i in range(0,len(self.transiciones)):
			if self.transiciones[i][0] == simbolo:
				estado += [str(nodos[self.transiciones[i][1]].simbolo)]
		return estado 

	def agregar_transicion(self,simbolo,siguiente):
		temp = [simbolo,siguiente]
		self.transiciones.append(temp)

	def agregrar_estado(self,estado):
		self.estados.append(estado)

	def comparar_estados(self,estados):
		i = 0
		elementos = 0
		if len(estados) != len(self.estados):
			return False
		for i in range(0,len(estados)):
			if estados[i] in self.estados:
				elementos += 1
		if elementos == len(self.estados):
			return True
		else:
			return False

def final(finales,estados_alcanzables,estados):
	aux = 0
	i =  0
	for i in range(0,len(estados_alcanzables)):
		aux = int(estados_alcanzables[i])
		if estados[aux] in finales:
			return True

def get_elemento(Nuevos_estados,estados):
	i = 0
	for i in range(0,len(Nuevos_estados)):
		if Nuevos_estados[i].comparar_estados(estados):
			return Nuevos_estados[i].simbolo

def crear_trancisiones(estados,transiciones,simbolos):
	i = 0
	N_transiciones = []
	for i in range(0,len(estados)):
		j = 0
		for j in range(0,len(simbolos)):
			aux = Ir_a(transiciones,simbolos[j],estados[i])
			if len(aux) != 0:
				N_transiciones.append([estados[i].simbolo,simbolos[j],get_elemento(estados,aux)])
	return N_transiciones


def crea_linea(simbolos,izq,der):
	return (" "*izq)+",".join(simbolos)+(" "*der)+"	|"

def Ir_a(transiciones,simbolo,Nuevo_estado_AFD):
	i = 0
	estados_alcanzables = []
	for i in range(0,len(Nuevo_estado_AFD.estados)):
		j = 0
		for j in range(0,len(transiciones)):
			if Nuevo_estado_AFD.estados[i] == transiciones[j][0] and transiciones[j][1] == simbolo:
				estados_alcanzables += [transiciones[j][2]]
				estados_alcanzables += Cerradura_E(transiciones,transiciones[j][2])
	return estados_alcanzables

def Cerradura_E(transiciones,estado_actual):
	estados_alcanzables = []
	for i in range(0,len(transiciones)):
		if estado_actual == transiciones[i][0] and transiciones[i][1] == "E":
			estados_alcanzables.append(transiciones[i][2])
	if len(estados_alcanzables) != 0:
		i = 0
		for i in range(0,len(estados_alcanzables)):
			estados_alcanzables += Cerradura_E(transiciones,estados_alcanzables[i])
		return estados_alcanzables
	else:
		return []

def analisis(estados,alcanzables):
	aux = 0
	i = 0
	if len(alcanzables) != 0:
		for i in range(0,len(estados)):
			if estados[i].comparar_estados(alcanzables) == True:
				aux = 1
	else:
		return False
	if aux == 1:
		return False
	else:
		return True



def imprimir_tabla_nueva(nodos,simbolos):
	i = 0
	tam_1 = 0
	tam_2 = 0
	for i in range(0,len(nodos)):
		aux = ""
		if nodos[i].inicial == True:
				aux += "->"
		if nodos[i].final == True:
			aux += "*"
		aux += str(nodos[i].simbolo)
		segmento = crea_linea([aux],2,2)
		if len(segmento) > tam_1:
			tam_1 = len(segmento)
		j = 0
		for j in range(0,len(simbolos)):
			segmento = crea_linea(nodos[i].siguiente(simbolos[j],nodos),1,2)
			if len(segmento) > tam_2:
				tam_2 = len(segmento)
		if len(segmento) > tam_2:
			tam_2 = len(segmento)
	der_1 = tam_1-int(tam_1/2)
	der_2 = tam_2-int(tam_2/2)
	i = 0
	linea = "	|	" + crea_linea([" "],2,der_1-1)
	for i in range(0,len(simbolos)):
		der_N = der_2-len(",".join([str(simbolos[i])]))
		linea += crea_linea([simbolos[i]],3,der_N)
	print(linea)
	i = 0
	for i in range(0,len(nodos)):
		aux = ""
		if nodos[i].inicial == True:
			aux += "->"
		if nodos[i].final == True:
			aux += "*"
		aux += str(nodos[i].simbolo)
		der_N = der_1-len(aux)
		linea = "	|	"+crea_linea([aux],2,der_N)
		j = 0
		for j in range(0,len(simbolos)):
			der_2_N = der_2-len(",".join(nodos[i].siguiente(simbolos[j],nodos)))+1
			linea += crea_linea(nodos[i].siguiente(simbolos[j],nodos),2,der_2_N)
		#print("-"*len(linea))
		print(linea)

def completar(simbolos,actuales):
	aux = []
	i = 0
	for i in range(0,len(simbolos)):
		if (simbolos[i] in actuales) == False:
			aux.append(simbolos[i])
	return aux

def simbolos_transitivos(nodo,simbolos):
	aux = []
	i = 0
	for i in range(0,len(simbolos)):
		j = 0
		for j in range(0,len(nodo.transiciones)):
			if simbolos[i] in nodo.transiciones[j]:
				aux.append(simbolos[i])
	return aux

#Regresa la posicion de un elemento en un arreglo de nodos
def posicion(nodos,elemento):
	i = 0
	posicion = -1
	for i in range(0,len(nodos)):
		if nodos[i].simbolo == elemento:
			posicion = i
	return posicion