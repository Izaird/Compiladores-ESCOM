#Clase que guarda los metodos de un estado
class Estado:
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
		estado = -1
		for i in range(0,len(self.transiciones)):
			if self.transiciones[i][0] == simbolo:
				estado = self.transiciones[i][1]
		return estado

def imprimir_tabla(nodos,simbolos):
	linea = "|       |"
	i = 0
	for i in range(0,len(simbolos)):
		linea += ("  "+simbolos[i]+"  |")
	separacion = ""
	i = 0
	for i in range(0,len(linea)):
		separacion += "-"
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
			if nodos[nodos[j].siguiente(simbolos[i])].numero != -1:
				linea += ("  "+str(nodos[nodos[j].siguiente(simbolos[i])].numero)+"  |")
			else:
				linea += (" "+str(nodos[nodos[j].siguiente(simbolos[i])].numero)+"  |")
		print(linea)
		print(separacion)

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
