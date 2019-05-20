// Regresa el tamaño de la cadena
int size(char* cadena)
{
	int tam = 0;
	while(cadena[tam]){ tam ++; }
	return tam;
}

// Concatena dos cadenas 
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

// Compara dos cadenas
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


// Obtiene la cadena
char* lexema_aux (char* lex)
{
	char* temp = (char*)malloc(sizeof(char)*size(lex));
	int i = 0;
	while(lex[i] != 32 && lex[i] != 10 && lex[i] != 9
		&& lex[i] != ';' && lex[i] != '=' && lex[i] != '+'
		&& lex[i] != '-' && lex[i] != '/' && lex[i] != '^'
		&& lex[i] != '*' && lex[i] != ',' && lex[i] != ')')
	{
		temp[i] = lex[i];
		i ++;
	}
	return temp;
}

// Potencia de cadenas
char* pow_s(char* cadena,int potencia){
	char* aux = (char*)malloc(sizeof(char)*1);
	aux[0] = '\n';
	int i;
	for(i = 0; i < potencia; i ++)
			aux = conca(cadena,aux);
	return aux;
}


//Concatenacion de cadenas con enteros
char* conca_i(char* cadena, int entero){
	char* aux = (char*)malloc(sizeof(char)*1);
	aux[0] = '\n';
	char* num = (char*)malloc(sizeof(char)*10);
	sprintf(num, "%d", entero);
	aux = conca(cadena,num);
	return aux;
}


//Concatenacion de cadenas con racionales
char* conca_f(char* cadena, double racional){
	char* aux = (char*)malloc(sizeof(char)*1);
	aux[0] = '\n';
	char* num = (char*)malloc(sizeof(char)*10);
	sprintf(num, "%.4g", racional);
	aux= conca(cadena,num);
	return aux;
}


