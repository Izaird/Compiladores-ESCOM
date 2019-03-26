#Clase para crear los estados 
class Estado:
	def __init__(self,numero,inicial,final):
		self.numero = numero
		self.inicial = inicial
		self.final = final
		self.transiciones = []

	def agregar_transicion(self,simbolo,siguiente):
		temp = [simbolo,siguiente]
		self.transiciones.append(temp)

	def siguiente(self,simbolo,nodos):
		i = 0
		estado = []
		for i in range(0,len(self.transiciones)):
			if self.transiciones[i][0] == simbolo:
				estado = estado + [str(nodos[self.transiciones[i][1]].numero)]
		return estado
#Imprime la tabla con las transiciones
def imprimir_tabla(nodos,simbolos):
	linea = "|       |"
	i = 0
	for i in range(0,len(simbolos)):
		linea += ("	"+simbolos[i]+"	|")
	linea +=("	ε	|")
	separacion = ""
	i = 0
	
	print(separacion)
	print(linea)
	print(separacion)
	j = 0
	for j in range(0,len(nodos)):
		linea = "| "
		if nodos[j].numero != -1:
			if nodos[j].inicial == True:
				linea += "->"
			else:
				linea += "  "
			if nodos[j].final == True:
				linea += "*"
			else:
				linea += " "
		else:
			linea += "  "
		linea +=str(nodos[j].numero)+"  |"
		i = 0
		for i in range(0,len(simbolos)):
			linea += ("	"+",".join(nodos[j].siguiente(simbolos[i],nodos))+"	|")
		linea += ("	"+",".join(nodos[j].siguiente('E',nodos))+"	|")
		print(linea)
		print(separacion)

#Completa los simbolos que faltan para hacer las trancisiones
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
		if nodos[i].numero == int(elemento):
			posicion = i
	return posicion