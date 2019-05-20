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
	int i = 0;
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
int add(char* lexema,int tipo,union Data val_entrada)
{
	int i = get_id(lexema);
	if(i == -1 || i == -2)
	{
		table *nodo = (table*)malloc(sizeof(table));
		nodo->lexema = lexema;
		nodo->tipo = tipo;
		nodo->valor = val_entrada;
		
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
				printf("int   %d\n",aux->valor.e);
			break;
			case 1:
				printf("float   %g\n",aux->valor.f);
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
	switch(a->tipo)
	{
		case 0:
			aux = a->valor.e;
		break;
		case 1:
			aux = a->valor.f;
		break;
	}
	return aux;
}

//Realiza operaciones y almacena resultados de ser necesario
table* operacion(table* variable,float num,int orden,int operacion){
	table* aux = NULL;
	if(variable != NULL && variable->tipo != 2)
	{
		aux = (table*)malloc(sizeof(table));
		if(orden == 0)
		{
			switch(operacion)
			{
				case 0: // suma
					val.f = ((variable->tipo == 0) ? variable->valor.e : variable->valor.f) + num;
					aux->tipo = 1;
					aux->valor = val;
				break;
				case 1:// resta
					val.f = ((variable->tipo == 0) ? variable->valor.e : variable->valor.f) - num;
					aux->tipo = 1;
					aux->valor = val;
				break;
				case 2:// division
					val.f = ((variable->tipo == 0) ? variable->valor.e : variable->valor.f) / num;
					aux->tipo = 1;
					aux->valor = val;
				break;
				case 3: // multiplicacion
					val.f = ((variable->tipo == 0) ? variable->valor.e : variable->valor.f) * num;
					aux->tipo = 1;
					aux->valor = val;
				break;
				case 4:// potencia
					val.f = pow(((variable->tipo == 0) ? variable->valor.e : variable->valor.f),num);
					aux->tipo = 1;
					aux->valor = val;
				break;
			}
		}else
		{
			switch(operacion)
			{
				case 0: // suma
					val.f = num + ((variable->tipo == 0) ? variable->valor.e : variable->valor.f);
					aux->tipo = 1;
					aux->valor = val;
				break;
				case 1:// resta
					val.f = num - ((variable->tipo == 0) ? variable->valor.e : variable->valor.f);
					aux->tipo = 1;
					aux->valor = val;
				break;
				case 2:// division
					val.f = num / ((variable->tipo == 0) ? variable->valor.e : variable->valor.f);
					aux->tipo = 1;
					aux->valor = val;
				break;
				case 3: // multiplicacion
					val.f = num * ((variable->tipo == 0) ? variable->valor.e : variable->valor.f);
					aux->tipo = 1;
					aux->valor = val;
				break;
				case 4:// potencia
					val.f = pow(num,((variable->tipo == 0) ? variable->valor.e : variable->valor.f));
					aux->tipo = 1;
					aux->valor = val;
				break;
			}
		}	
	}
	return aux;
}


void print_var(struct table* numero){
	table* aux = numero;
		if(aux != NULL)
		{
			switch(aux->tipo)
			{
				case 0:
					printf("\tResultado: %d\n",aux->valor.e);
				break;
				case 1:
					printf("\tResultado: %.8g\n",aux->valor.f);
				break;
				case 2:
					printf("\tResultado: %s\n",aux->valor.s);
				break;
			}
		}
		else
			printf("\t\e[35mOperacion no valida\e[0m\n");

}

void declaration_var(char* variable, double valor, int tipo_var){
	int valor_int =(int)valor;
	if (tipo_var == 0){
		char* temp = lexema_aux(variable);
		val.e = valor_int;
		if(add(temp,0,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %d\n",temp,valor_int);
	}

	else{
		char* temp =  lexema_aux(variable);
		val.f = valor;
		if(add(temp,1,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %g\n",temp,valor);
	}
}

// Cambio del valor de la variable, tiene que estar previamente declarada
void change_val(char* variable, double valor,int tipo_val){
	int valor_int =(int)valor;
	if (tipo_val == 0){
		char* temp =  lexema_aux(variable);
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 0)
			{
				val.e = valor_int;
				aux->valor = val;
				printf("\tResultado: %s = %d\n",temp,aux->valor.e);
			}
			else
			{	
				val.f = valor_int;
				aux->valor = val;
				printf("\tResultado: %s = %g\n",temp,aux->valor.f);
			}
		}
		else
			printf("\t\e[35mVariable no declarada\e[0m\n");
	}
	else{
		char* temp = lexema_aux(variable);
		table* aux =  get_nodo(temp);
		val.f = valor;
		if(aux != NULL)
		{
			if(aux->tipo == 1)
			{
				aux->valor.f = valor;
				printf("\tResultado: %s = %f\n",temp,aux->valor.f);
			}
			else
			{	
				printf("\t\e[35mTipo de dato incompatible\e[0m\n");
			}
		}
		else
			printf("\t\e[35mVariable no declarada\e[0m\n");
	}
}