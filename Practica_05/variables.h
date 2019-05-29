// Imprime variable tipo expresion variable
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
			printf("\t\e[31mOperacion no valida\e[0m\n");

}

// Imprime variable previamente declarada 
void print_var_lit(char* variable){
		char* temp = lexema_aux(variable);
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 0)
				printf("\tResultado: %s = %d\n",aux->lexema,aux->valor.e);
			else if(aux->tipo == 1)
				printf("\tResultado: %s = %f\n",aux->lexema,aux->valor.f);
			else
				printf("\tResultado: %s = %s\n",aux->lexema,aux->valor.s);

		}
		else
			printf("\t\e[31mVariable no declarada\e[0m\n");
}

// Declaracion de una variable numerica
void declaration_var(char* variable, double valor, int tipo_var){
	int valor_int =(int)valor;
	if (tipo_var == 0){
		char* temp = lexema_aux(variable);
		val.e = valor_int;
		if(add(temp,0,val) == false)
			printf("\t\e[31mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %d\n",temp,valor_int);
	}

	else{
		char* temp =  lexema_aux(variable);
		val.f = valor;
		if(add(temp,1,val) == false)
			printf("\t\e[31mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %g\n",temp,valor);
	}
}

// Declaracion de una variable tipo string
void declaration_var_s(char* variable, char* valor){
	if (valor==0){
		char* temp = lexema_aux(variable);
		char* cad = (char*)malloc(1);
		cad[0] = '\0';
		val.s = cad;
		if(add(temp,2,val) == false)
			printf("\t\e[31mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s\n",temp);
	}
	else{
		char* temp = lexema_aux(variable);
		val.s = valor;
		if(add(temp,2,val) == false)
			printf("\t\e[31mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %s\n",temp,valor);
	}
}


// Cambio del valor de la variable tipo real(int, float)
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
			printf("\t\e[31mVariable no declarada\e[0m\n");
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
				printf("\t\e[31mTipo de dato incompatible\e[0m\n");
			}
		}
		else
			printf("\t\e[31mVariable no declarada\e[0m\n");
	}
}

// Cambia el valor de una variable tipo string
void change_val_s(char* variable, char* valor){
		char* temp =  lexema_aux(variable);
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 2)
			{
				val.s = valor;
				aux->valor = val;
				printf("\tResultado: %s = %s\n",temp,aux->valor.s);
			}
			else
				printf("\t\e[31mTipo de dato incompatible\e[0m\n");
		}
		else
			printf("\t\e[31mVariable no declarada\e[0m\n");
}

// Suma dos variables
struct table* add_var(struct table *var_1, struct table* var_2){
    table* aux = NULL;
			if(var_1 != NULL && var_2 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if(var_1->tipo == 2 && var_2->tipo == 2)
				{
					char* resultado = conca(var_1->valor.s,var_2->valor.s);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}else if(var_1->tipo == 2 || var_2-> tipo == 2)
				{
					char* num = (char*)malloc(sizeof(char)*10);
					char* resultado;
					if(var_1->tipo == 2)
					{
						sprintf(num, "%.4g", (var_2->tipo == 0) ? var_2->valor.e : var_2->valor.f);
						resultado = conca(var_1->valor.s,num);
					}
					else
					{
						sprintf(num, "%.4g", (var_1->tipo == 0) ? var_1->valor.e : var_1->valor.f);
						resultado = conca(num,var_2->valor.s);
					}
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}else
				{
					val.f = ((var_1->tipo == 0) ? var_1->valor.e : var_1->valor.f) + ((var_2->tipo == 0) ? var_2->valor.e : var_2->valor.f);
					aux->tipo = 1;
					aux->valor = val;
				}
			}
			return aux;
}

// Resta dos variables
struct table* sub_var(struct table *var_1, struct table* var_2){
    	table* aux = NULL;
			if(var_1 != NULL && var_2 != NULL && var_1->tipo != 2 && var_2->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				val.f = ((var_1->tipo == 0) ? var_1->valor.e : var_1->valor.f) - ((var_2->tipo == 0) ? var_2->valor.e : var_2->valor.f);
				aux->tipo = 1;
				aux->valor = val;
			}
			return aux;	
}

// Multiplica dos variables
struct table* mul_var(struct table *var_1, struct table* var_2){
    			table* aux = NULL;
			if(var_1 != NULL && var_2 != NULL && var_1->tipo != 2 && var_2->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				val.f = ((var_1->tipo == 0) ? var_1->valor.e : var_1->valor.f) * ((var_2->tipo == 0) ? var_2->valor.e : var_2->valor.f);
				aux->tipo = 1;
				aux->valor = val;
			}
			return aux;
}

// Divide dos variables
struct table* div_var(struct table *var_1, struct table* var_2){
    			table* aux = NULL;
			if(var_1 != NULL && var_2 != NULL && var_1->tipo != 2 && var_2->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				val.f = ((var_1->tipo == 0) ? var_1->valor.e : var_1->valor.f) / ((var_2->tipo == 0) ? var_2->valor.e : var_2->valor.f);
				aux->tipo = 1;
				aux->valor = val;
			}
			return aux;
}

// Potencia de variables, la primera variable es la base y la segunda la potencia 
struct table* pow_var(struct table *var_1, struct table* var_2){
    			table* aux = NULL;
			if(var_1 != NULL && var_2 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if(var_1->tipo == 2 && var_2-> tipo == 0 || var_2-> tipo == 1)
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = (var_2->tipo == 0) ? var_2->valor.e : var_2->valor.f;
					for(i = 0; i < fin; i ++)
						resultado = conca(var_1->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}else
				{
					val.f = pow(((var_1->tipo == 0) ? var_1->valor.e : var_1->valor.f),((var_2->tipo == 0) ? var_2->valor.e : var_2->valor.f));
					aux->tipo = 1;
					aux->valor = val;
				}
			}
			return aux;
}

// Realiza operaciones de variables y reales
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

// Realiza una suma de una variable y un entero
struct table* add_var_i(struct table *var_1, int var_2,int orden){
	table* aux = NULL;
	if(var_1 != NULL)
	{
		aux = (table*)malloc(sizeof(table));
		if(var_1->tipo == 2)
		{
			char* num = (char*)malloc(sizeof(char)*10);
			char* resultado;
			sprintf(num, "%d", var_2);
			resultado = conca(var_1->valor.s,num);
			val.s = resultado;
			aux->tipo = 2;
			aux->valor = val;
		}
		else
			aux = operacion(var_1,var_2,orden,0);
	}
	return aux;	
}

// Realiza una variable de una variable y un recional
struct table* add_var_f(struct table *var_1, float var_2,int orden){
	if (orden==0){
		table* aux = NULL;
		if(var_1 != NULL)
		{
			aux = (table*)malloc(sizeof(table));
			if(var_1->tipo == 2)
			{
				char* num = (char*)malloc(sizeof(char)*10);
				char* resultado;
				sprintf(num, "%g", var_2);
				resultado = conca(var_1->valor.s,num);
				val.s = resultado;
				aux->tipo = 2;
				aux->valor = val;
			}
			else
				aux = operacion(var_1,var_2,0,0);
		}
	return aux;
	}

	else{
		table* aux = NULL;
		if(var_1 != NULL)
		{
			aux = (table*)malloc(sizeof(table));
			if(var_1->tipo == 2)
			{
				char* num = (char*)malloc(sizeof(char)*10);
				char* resultado;
				sprintf(num, "%g", var_2);
				resultado = conca(num,var_1->valor.s);
				val.s = resultado;
				aux->tipo = 2;
				aux->valor = val;
			}
			else
				aux = operacion(var_1,var_2,1,0);
		}
	return aux;
	}
	

}

// Potencia de una variable con una entero
struct table* pow_var_i(struct table *var_1, int var_2,int orden){
	if(orden ==0){
			table* aux = NULL;
			if(var_1 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if(var_1->tipo != 2)
					aux = operacion(var_1,var_2,0,4);
				else
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = var_2;
					for(i = 0; i < fin; i ++)
						resultado = conca(var_1->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
			}
			return  aux;
	}
	else
	{
			table* aux = NULL;
			if(var_1 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if(var_1->tipo != 2)
					aux = operacion(var_1,var_2,0,4);
				else
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = var_2;
					for(i = 0; i < fin; i ++)
						resultado = conca(var_1->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
			}
			return  aux;
	}
	
}

// Suma una variable con una cadena
struct table* add_var_s(struct table *var_1, char * var_2){
			table* aux = NULL;
			if(var_1 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				char* resultado;
				if(var_1->tipo == 2)
					resultado = conca(var_1->valor.s,var_2);
				else
				{
					char* num = (char*)malloc(sizeof(char)*10);
					sprintf(num, "%g", (var_1->tipo == 0) ? var_1->valor.e : var_1->valor.f);
					resultado = conca(num,var_2);
				}	
				val.s = resultado;
				aux->tipo = 2;
				aux->valor = val;
			}
			return aux;
}

// Potencia con un base que es un string y el exponente una variable real
struct table* pow_var_s(struct table *var_1, char * var_2){
				table* aux = NULL;
			if(var_1 != NULL && var_1->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				char* resultado = (char*)malloc(sizeof(char)*1);
				resultado[0] = '\n';
				int i,fin = (var_1->tipo == 0) ? var_1->valor.e : var_1->valor.f;
				for(i = 0; i < fin; i ++)
					resultado = conca(var_2,resultado);
				val.s = resultado;
				aux->tipo = 2;
				aux->valor = val;
			}
			return aux;
}

//Retorna el nodo de la variable 
struct table * var_to_expvar(char * variable){
	char* nombre = lexema_aux(variable);
	table* aux = get_nodo(nombre);
	if(aux == NULL)
		printf("\t\e[31mVariable '%s' no declarada\e[0m\n",nombre);
	return aux;	
}

//Asigna el valor de exp_var a una variable 
void asign_val(char *variable, struct table * resultado){
		char* temp = lexema_aux(variable);
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 2)
			{
				if(resultado->tipo == 2)
				{
					aux->valor.s = resultado->valor.s;
					printf("\tResultado: %s\n", aux->valor.s);
				}
				else
					printf("\t\e[31mTipos no compatibles\e[0m\n");
			}
			else if(aux->tipo == 0)
			{
				if(resultado->tipo == 0)
				{
					aux->valor.e = resultado->valor.e;
					printf("\tResultado: %d\n", aux->valor.e);
				}
				else if (resultado->tipo == 1)
				{
					aux->valor.e = resultado->valor.f;
					printf("\tResultado: %d\n", aux->valor.e);
				}
				else
					printf("\t\e[31mTipos no compatibles\e[0m\n");
			}
			else
			{
				if(resultado->tipo == 0)
				{
					aux->valor.f = resultado->valor.e;
					printf("\tResultado: %d\n", aux->valor.f);
				}
				else if (resultado->tipo == 1)
				{
					aux->valor.f = resultado->valor.f;
					printf("\tResultado: %.5g\n", aux->valor.f);
				}
				else
					printf("\t\e[31mTipos no compatibles\e[0m\n");
			}
		}
		else
			printf("\t\e[31mVariable no declarada\e[0m\n");
}

// Compara dos variables de cualquier tipo, la unica condicion para que se ejecute
// es que sean de tipos compatibles
void var_comp(struct table *var_01,struct table *var_02){
	if (var_01!= NULL && var_02 != NULL){
		if(var_01->tipo!=2 || var_02->tipo!=2 ){
			printf("\t\e[31mTipos no compatibles\e[0m\n");
		}
		else{
			int a = size(var_01->valor.s);
			int b = size(var_02->valor.s);
			if (a>b){
				printf("\tTRUE\n");
			}
			else{
				printf("\tFALSE\n");
			}
		}
	}

}

