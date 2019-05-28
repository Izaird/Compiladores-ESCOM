// Regresa el tamaño de la cadena
int size(char* cadena){
	int tam = 0;
	while(cadena[tam]){ tam ++; }
	return tam;
}

// Concatena dos cadenas 
char* conca(char* cadena_1,char* cadena_2){
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
int comparation(char* cadena_1,char* cadena_2){
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
char* lexema_aux (char* lex){
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
	if (potencia>= 0){
		char* aux = (char*)malloc(sizeof(char)*1);
		aux[0] = '\n';
		int i;
		for(i = 0; i < potencia; i ++)
		aux = conca(cadena,aux);
		return aux;
	}
	else{
		int l, i; 
		potencia *= -1;
    	char *begin_ptr, *end_ptr, ch; 
	
    	// Obtiene el tamaño del cadenaing
    	l = strlen(cadena); 
	

    	begin_ptr = cadena; 
    	end_ptr = cadena; 
	
    	// Se mueve end_ptr al ultimo caracter 
    	for (i = 0; i < l - 1; i++) 
    	    end_ptr++; 
	
    	// Cambia el caracter del inicio al final
    	for (i = 0; i < l / 2; i++) { 
		
    	    // Cambio de caracter 
    	    ch = *end_ptr; 
    	    *end_ptr = *begin_ptr; 
    	    *begin_ptr = ch; 
	
    	    // Se actualizan los apuntadores 
    	    begin_ptr++; 
    	    end_ptr--; 
    	}
		char* aux = (char*)malloc(sizeof(char)*1);
		aux[0] = '\n';
		for(i = 0; i < potencia; i ++)
		aux = conca(cadena,aux);
		return aux; 
	}
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

//Invierte cadena
char* reverse_s(char* cadena) 
{ 
    int l, i; 
    char *begin_ptr, *end_ptr, ch; 
  
    // Obtiene el tamaño del cadenaing
    l = strlen(cadena); 
  
    // Set the begin_ptr and end_ptr 
    // initially to start of cadenaing 
    begin_ptr = cadena; 
    end_ptr = cadena; 
  
    // Move the end_ptr to the last character 
    for (i = 0; i < l - 1; i++) 
        end_ptr++; 
  
    // Swap the char from start and end 
    // index using begin_ptr and end_ptr 
    for (i = 0; i < l / 2; i++) { 
  
        // swap character 
        ch = *end_ptr; 
        *end_ptr = *begin_ptr; 
        *begin_ptr = ch; 
  
        // update pointers positions 
        begin_ptr++; 
        end_ptr--; 
    } 
	return cadena;
} 
  