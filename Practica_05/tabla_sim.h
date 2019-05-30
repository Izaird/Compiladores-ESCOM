union Data {
   int e;
   float f;
   char* s;
};

typedef struct table
{
	int id;
	int tipo;
	char* lexema;
	union Data valor;
	struct table *siguiente;
	struct table *anterior;
}table; 

table *primero = NULL;
table *ultimo = NULL;

union Data val;

//Regresa el nodo de un lexema
table* get_nodo(char* lexema)
{
	int i;
	table *aux = primero;
	while(aux != NULL){
		if(comparation(aux->lexema,lexema))
			return aux;
		aux = aux->siguiente;
		i++;
	}	
	return aux;
}

// Retorna el ID de un lexema 
int get_id(char* lexema){
	int i = 0;
	if(primero != NULL){
		table *aux = primero;
		do{
			if(comparation(aux->lexema,lexema))
				return i;
			aux = aux->siguiente;
			i++;
		}while(aux != NULL);	
		return -1;
	}
	return -2;
}

// Agrega el elemento a la tabla de simbolos 
int add(char* lexema,int tipo,union Data val_entrada){
	int i = get_id(lexema);
	if(i == -1 || i == -2)
	{
		table *nodo = (table*)malloc(sizeof(table));
		nodo->lexema = lexema;
		nodo->tipo = tipo;
		nodo->valor = val_entrada;
		
		if(primero == NULL){
			nodo->id = 0;
			nodo->anterior = NULL;
			primero = nodo;
			ultimo = nodo;
		}
		else{
			nodo->id = ultimo->id + 1;
			ultimo->siguiente = nodo;
			nodo->anterior = ultimo;
			nodo->siguiente = NULL;
			ultimo = nodo;
		}
		return true;
	}
	else
		return false;

}

// Retorna el lexema de un ID
char* get_lex(int id){
	char *lexema = (char*)malloc(sizeof(char)*100);
	table *aux = primero;
	for(int i = 0; i <= id; i++){
		lexema = aux->lexema;
		aux = aux->siguiente;
	}
	return lexema;
}

// Muestra la tabla de simbolos se puede ver en cualquier momento con el comando t@b
void mostrar()
{
	table *aux = primero;
	while(aux != NULL){	
		printf(" %d  %s    ",aux->id,aux->lexema);
		switch(aux->tipo){
			case 0:
				printf("int   %d\n",aux->valor.e);
				break;
			case 1:
				printf("float   %g\n",aux->valor.f);
				break;
			case 2:
				printf("string   %g\n",aux->valor.s);
				break;
			default:
				printf("Desconocido\n");
				break;
		}
		aux = aux->siguiente;
	}
}

//Obtiene el valor de un flotante 
float val_flot(table* a){
	float aux = 0;
	switch(a->tipo){
		case 0:
			aux = a->valor.e;
			break;
		case 1:
			aux = a->valor.f;
			break;
	}
	return aux;
}

