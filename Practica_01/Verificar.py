def recorre(nodos,simbolos,indice,cadena,camino,total,valido):
	temp = camino
	if nodos[indice].numero != -1:
		if len(cadena) == 0:
			if nodos[indice].final == True:
				valido.append(1)
				temp = camino + [nodos[indice].numero]
				mostrar(temp,total,nodos)
		else:
			if (cadena[0] in simbolos) == False:
				temp = camino + [-2]
				recorre(nodos,simbolos,indice,cadena[1:],temp,total,valido)
			else:
				i = 0
				cad_temp = cadena
				for i in range(0,len(nodos[indice].transiciones)):
					if nodos[indice].transiciones[i][0] == cadena[0]:
						temp = camino + [indice]
						recorre(nodos,simbolos,nodos[indice].transiciones[i][1],cad_temp[1:],temp,total,valido)

def mostrar(recorrido,cadena,nodos):
	print("\033[1;32m"+"Cadena valida"+"\033[0;m"+"\nRecorrido:")
	camino = ""
	for j in range(0,len(recorrido)):
		if recorrido[j] == -2:
			camino += ("\033[1;34m ("+cadena[j]+")\033[0;m -> ")
		else:
			if (j + 1) <= len(cadena):
				camino += (str(nodos[recorrido[j]].numero)+"("+(cadena[j])+") -> ")
	camino += str(recorrido[j])
	print(camino)
