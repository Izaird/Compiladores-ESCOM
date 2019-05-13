#define true 1
#define false 0

/*union Data {
   int e;
   float f;
};*/

typedef struct table
{
	int id;
	int tipo;
	char* lexema;
	//union Data valor;
	int valor_e;
	float valor_f;
	
	struct table *siguiente;
	struct table *anterior;
}table; 

table *primero = NULL;
table *ultimo = NULL;

//union Data val;

/**Regresa el tamaño de una cadena**/
int size(char* cadena)
{
	int tam = 0;
	while(cadena[tam]){ tam ++; }
	return tam;
}

/**Concatenacion de dos cadenas**/
char* conca(char* cadena_1,char* cadena_2)
{
	int i = 0,j = 0,tam = (size(cadena_1) + size(cadena_2));
	char* bufer = (char*)malloc(sizeof(char)*tam);
	do
	{
		bufer[j] = cadena_1[i];
		i ++;
		j ++;
	}while(cadena_1[i] != '\0');
	i = 0;
	do
	{
		bufer[j] = cadena_2[i];
		i ++;
		j ++;
	}while(cadena_2[i] != '\0');
	return bufer;
}

/**Compara dos cadenas**/
int comparation(char* cadena_1,char* cadena_2)
{
	if(size(cadena_1) == size(cadena_2))
	{
		int i,bandera = 1;
		for(i = 0; i <= size(cadena_1); i ++)
		{
			if(cadena_1[i] != cadena_2[i])
				bandera = 0;
		}	
		if(bandera == 1)
			return true;
		else
			return false;
	}
	else
		return false;
}

/**Regresa el nodo de un lexema**/
table* get_nodo(char* lexema)
{
	int i;
	table *aux = primero;
	do
	{
		if(comparation(aux->lexema,lexema))
			return aux;
		aux = aux->siguiente;
		i++;
	}while(aux != NULL);	
	return aux;
}

/**Regresa el id de un lexema**/
int get_id(char* lexema)
{
	int i=0;
	if(primero != NULL)
	{
		table *aux = primero;
		do
		{
			if(comparation(aux->lexema,lexema))
				return i;
			aux = aux->siguiente;
			i++;
		}while(aux != NULL);	
		return -1;
	}
	return -2;
}

/**Agrega elemento a la tabla de simbolos**/
int add(char* lexema,int tipo,int val_i,float val_f)//union Data val_entrada)
{
	int i = get_id(lexema);
	if(i == -1 || i == -2)
	{
		table *nodo = (table*)malloc(sizeof(table));
		nodo->lexema = lexema;
		nodo->tipo = tipo;


		nodo->valor_e = val_i;
		nodo->valor_f = val_f;
		//nodo->valor = val_entrada;
		
		if(primero == NULL)
		{
			nodo->id = 0;
			nodo->anterior = NULL;
			primero = nodo;
			ultimo = nodo;
		}
		else
		{
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

/**Regresa el lexema de un id**/
char* get_lex(int id)
{
	int i;
	char *lexema = (char*)malloc(sizeof(char)*100);
	table *aux = primero;
	for(i = 0; i <= id; i++)
	{
		lexema = aux->lexema;
		aux = aux->siguiente;
	}
	return lexema;
}


void mostrar()
{
	table *aux = primero;
	while(aux != NULL)
	{	

		printf(" %d  %s    ",aux->id,aux->lexema);
		switch(aux->tipo)
		{
			case 0:
				printf("int   %d\n",aux->valor_e);
			break;
			case 1:
				printf("float   %g\n",aux->valor_f);
			break;
			default:
				printf("Desconocido\n");
			break;
		}
		aux = aux->siguiente;
	}
}

