class Estado:
    def __init__(self, e_numero, e_inicial, e_final):
        self.e_numero = e_numero
        self.e_inicial = e_inicial
        self.e_final = e_final
    

# Convierte la linea que se mande de un archivo en una lista
def leer(last_line):
    automata = open("automata.txt","r")
    automata.seek(last_line)
    cadena = automata.readline()
    lista_final = []
    i = 0
    aux = ""
    aux2 = len(cadena)

    for caracteres in cadena:
        if (caracteres!= ','):
            aux+=caracteres
            if(i == aux2-2):
                lista_final.append(aux.lstrip())
                aux =""
            
            i+=1

        else:
            lista_final.append(aux.lstrip())
            aux =""
            i+=1

    last_line = automata.tell()

            
    return (lista_final, last_line)




prueba = leer(0)

print((prueba))

