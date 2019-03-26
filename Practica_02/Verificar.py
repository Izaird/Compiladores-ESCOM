def recorre(nodos,simbolos,indice,cadena,camino,total,valido):
	temp = camino
	if nodos[indice].numero != -1:
		if len(cadena) == 0:
			if nodos[indice].final == True:
				valido.append(1)
				temp = camino + [[nodos[indice].numero,1]]
				mostrar(temp,total,nodos)
			else:
				i = 0
				for i in range(0,len(nodos[indice].transiciones)):
					if nodos[indice].transiciones[i][0] == 'E':
						temp = camino + [[indice,0]]
						recorre(nodos,simbolos,nodos[indice].transiciones[i][1],cadena,temp,total,valido)
		else:
			if (cadena[0] in simbolos) == False:
				temp = camino + [[-2,1]]
				recorre(nodos,simbolos,indice,cadena[1:],temp,total,valido)
			else:
				i = 0
				cad_temp = cadena
				for i in range(0,len(nodos[indice].transiciones)):
					if nodos[indice].transiciones[i][0] == cadena[0]:
						temp = camino + [[indice,1]]
						recorre(nodos,simbolos,nodos[indice].transiciones[i][1],cad_temp[1:],temp,total,valido)
					elif nodos[indice].transiciones[i][0] == 'E':
						temp = camino + [[indice,0]]
						recorre(nodos,simbolos,nodos[indice].transiciones[i][1],cad_temp,temp,total,valido)


def mostrar(recorrido,cadena,nodos):
	print("\033[1;32m"+"Cadena valida"+"\033[0;m"+"\nRecorrido:")
	camino = ""
	i = 0
	for j in range(0,len(recorrido)-1):
		if recorrido[j][1] == 0:
			camino += (str(nodos[recorrido[j][0]].numero)+"\033[1;33m"+"(ε)""\033[0;m"+" -> ")
		elif recorrido[j][0] == -2:
			camino += ("\033[1;31m("+cadena[i]+")\033[0;m -> ")
			i += 1
		else:
			if (i + 1) <= len(cadena):
				camino += (str(nodos[recorrido[j][0]].numero)+"\033[1;34m("+(cadena[i])+")\033[0;m -> ")
				i += 1
	camino += str(recorrido[j+1][0])
	print(camino)
