%{
	#include <stdio.h>
	#include <stdlib.h>	
	#include <math.h>
	#include "auxiliares.h"
	#include "Tabla_simbolos.h"
%}

/*Declaraciones de Bison*/
%union{
	struct table* Tabla_S;
	int entero;
	float flotante;
	char* cadena;
}

%token <entero> ENTERO
%token <flotante> REAL
%token <cadena> CADENA
%token <cadena> VARIABLE
%token IF
%token INT
%token FLOAT
%token STRING
%token POTENCIA
%type <entero> exp_i
%type <flotante> exp_f
%type <cadena> exp_c
%type <Tabla_S> exp_Var

%left '+' '-'
%left '*' '/' 
%left POTENCIA '^'

/* Gramaticas */
%%

input:	/* Cadena vacia */
		| input line
;

line: '\n'

	/** Manejo de constantes **/
	| exp_i '\n' { printf("\tResultado: %d\n\n", $1); }
	| exp_f '\n' { printf("\tResultado: %.4g\n\n", $1); }
	| exp_c '\n' { printf("\tResultado: %s\n\n", $1); }
	| exp_Var '\n'
	{
		table* aux = $1;
		if(aux != NULL)
		{
			switch(aux->tipo)
			{
				case 0:
					printf("\tResultado: %d\n",aux->valor.e);
				break;
				case 1:
					printf("\tResultado: %.4g\n",aux->valor.f);
				break;
				case 2:
					printf("\tResultado: %s\n",aux->valor.s);
				break;
			}
		}
		else
			printf("\t\e[35mOperacion no valida\e[0m\n");
	}
	//| exp_Var '\n' { printf("\tResultado: %.4g\n\n", $1); }
	
	/** Manejo de variables **/
		/** Manejo de variables enteras **/
	|VARIABLE ';'
	{
		char* temp = lexema_aux($1);
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
			printf("\t\e[35mVariable no declarada\e[0m\n");
	}
	| INT VARIABLE ';'
	{
		char* temp = lexema_aux($2);
		val.e = 0;
		if(add(temp,0,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = 0\n",temp);
	}
	| INT VARIABLE '=' exp_i';'
	{
		char* temp = lexema_aux($2);
		val.e = $4;
		if(add(temp,0,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %d\n",temp,$4);
	}
	| VARIABLE '=' exp_i ';'
	{
		char* temp =  lexema_aux($1);
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 0)
			{
				val.e = $3;
				aux->valor = val;
				printf("\tResultado: %s = %d\n",temp,aux->valor.e);
			}
			else
			{	
				val.f = $3;
				aux->valor = val;
				printf("\tResultado: %s = %g\n",temp,aux->valor.f);
			}
		}
		else
			printf("\t\e[35mVariable no declarada\e[0m\n");
	}

		/** Manejo de variables flotantes **/
	| FLOAT VARIABLE ';'
	{
		char* temp =  lexema_aux($2);
		val.f = 0;
		if(add(temp,1,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = 0\n",temp);
	}
	| FLOAT VARIABLE '=' exp_f';'
	{
		char* temp =  lexema_aux($2);
		val.f = $4;
		if(add(temp,1,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %g\n",temp,$4);
	}
	| FLOAT VARIABLE '=' exp_i';'
	{
		char* temp = lexema_aux($2);
		val.f = $4;
		if(add(temp,1,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %d\n",temp,$4);
	}
	| VARIABLE '=' exp_f ';'
	{
		char* temp = lexema_aux($1);
		table* aux =  get_nodo(temp);
		val.f = $3;
		if(aux != NULL)
		{
			if(aux->tipo == 1)
			{
				aux->valor.f = $3;
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

		/** Manejo de variables string **/
	| STRING VARIABLE ';'
	{
		char* temp = lexema_aux($2);
		char* cad = (char*)malloc(1);
		cad[0] = '\0';
		val.s = cad;
		if(add(temp,2,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s\n",temp);
	}
	| STRING VARIABLE '=' exp_c ';'
	{
		char* temp = lexema_aux($2);
		val.s = $4;
		if(add(temp,2,val) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %s\n",temp,$4);
	}
	| VARIABLE '=' exp_c ';'
	{
		char* temp =  lexema_aux($1);
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 2)
			{
				val.s = $3;
				aux->valor = val;
				printf("\tResultado: %s = %s\n",temp,aux->valor.s);
			}
			else
				printf("\t\e[35mTipos de dato incompatible\e[0m\n");
		}
		else
			printf("\t\e[35mVariable no declarada\e[0m\n");
	}

	/** Control de condicionales **/
	| IF '(' exp_i '>' exp_i ')' ';' '\n' 
	{ 
		if($3 > $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_i '<' exp_i ')' ';' '\n' 
	{ 
		if($3 < $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_f '>' exp_i ')' ';' '\n' 
	{ 
		if($3 > $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_f '<' exp_i ')' ';' '\n' 
	{ 
		if($3 < $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_i '>' exp_f ')' ';' '\n' 
	{ 
		if($3 > $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_i '<' exp_f ')' ';' '\n' 
	{ 
		if($3 < $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_f '>' exp_f ')' ';' '\n' 
	{ 
		if($3 > $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_f '<' exp_f ')' ';' '\n' 
	{ 
		if($3 < $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
;

/** Expresion que usa numeros enteros **/
exp_i: ENTERO {	$$ = $1; }
	| '-' exp_i { $$ = -$2; }
	| '(' exp_i ')'	{ $$ = $2; }
	| exp_i '+' exp_i	{ $$ = $1 + $3; }
	| exp_i '-' exp_i	{ $$ = $1 - $3; }
	| exp_i '*' exp_i	{ $$ = $1 * $3; }
	| exp_i '/' exp_i	{ $$ = $1 / $3; }
	| POTENCIA '(' exp_i ',' exp_i ')' ';' { $$ = pow($3,$5);}
;


/** Expresion que usa numeros reales **/
exp_f: REAL {	$$ = $1; }
	| '-' exp_f	{$$ = -$2; }
	| '(' exp_f ')'	{ $$ = $2; }
	| exp_f '+' exp_f	{ $$ = $1 + $3; }
	| exp_f '-' exp_f	{ $$ = $1 - $3; }
	| exp_f '*' exp_f	{ $$ = $1 * $3; }
	| exp_f '/' exp_f	{ $$ = $1 / $3; }
	| exp_i '+' exp_f {$$ = $1 + $3; }
	| exp_i '-' exp_f {$$ = $1 - $3; }
	| exp_i '*' exp_f {$$ = $1 * $3; }
	| exp_i '/' exp_f {$$ = $1 / $3; }
	| exp_f '+' exp_i {$$ = $1 + $3; }
	| exp_f '-' exp_i {$$ = $1 - $3; }
	| exp_f '*' exp_i {$$ = $1 * $3; }
	| exp_f '/' exp_i {$$ = $1 / $3; }
	| POTENCIA '(' exp_f ',' exp_f ')' ';' { $$ = pow($3,$5);}
	| POTENCIA '(' exp_f ',' exp_i ')' ';' { $$ = pow($3,$5);}
	| POTENCIA '(' exp_i ',' exp_f ')' ';' { $$ = pow($3,$5);}
;


/** Expresion que usa cadenas **/
exp_c: CADENA {	$$ = $1; }
	| '(' exp_c ')'	{ $$ = $2; }
	| exp_c '+' exp_c
	{
		$$ = conca($1,$3);
	}
	| exp_c '^' exp_i
	{
		char* aux = (char*)malloc(sizeof(char)*1);
		aux[0] = '\n';
		int i;
		for(i = 0; i < $3; i ++)
			aux = conca($1,aux);
		$$ = aux;
	}
	| POTENCIA '(' exp_c ',' exp_i ')' ';'
	{
		char* aux = (char*)malloc(sizeof(char)*1);
		aux[0] = '\n';
		int i;
		for(i = 0; i < $5; i ++)
			aux = conca($3,aux);
		$$ = aux;
	}
	| exp_c '+' exp_i
	{
		char* num = (char*)malloc(sizeof(char)*10);
		sprintf(num, "%d", $3);
		$$ = conca($1,num);
	}
	| exp_i '+' exp_c
	{
		char* num = (char*)malloc(sizeof(char)*10);
		sprintf(num, "%d", $1);
		$$ = conca(num,$3);
	}
	| exp_c '+' exp_f
	{
		char* num = (char*)malloc(sizeof(char)*10);
		sprintf(num, "%.4g", $3);
		$$ = conca($1,num);
	}
	| exp_f '+' exp_c
	{
		char* num = (char*)malloc(sizeof(char)*10);
		sprintf(num, "%.4g", $1);
		$$ = conca(num,$3);
	}
;

exp_Var: VARIABLE
		{
			char* nombre = lexema_aux($1);
			table* aux = get_nodo(nombre);
			if(aux == NULL)
				printf("\t\e[35mVariable '%s' no declarada\e[0m\n",nombre);
			$$ = aux;	
		}
		| '(' exp_Var ')'	{	$$ = $2;	}

			/** Operaciones con variables **/
		| exp_Var '+' exp_Var	
		{
			table* aux = NULL;
			if($1 != NULL && $3 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($1->tipo == 2 && $3->tipo == 2)
				{
					char* resultado = conca($1->valor.s,$3->valor.s);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}else if($1->tipo == 2 || $3-> tipo == 2)
				{
					char* num = (char*)malloc(sizeof(char)*10);
					char* resultado;
					if($1->tipo == 2)
					{
						sprintf(num, "%.4g", ($3->tipo == 0) ? $3->valor.e : $3->valor.f);
						resultado = conca($1->valor.s,num);
					}
					else
					{
						sprintf(num, "%.4g", ($1->tipo == 0) ? $1->valor.e : $1->valor.f);
						resultado = conca(num,$3->valor.s);
					}
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}else
				{
					val.f = (($1->tipo == 0) ? $1->valor.e : $1->valor.f) + (($3->tipo == 0) ? $3->valor.e : $3->valor.f);
					aux->tipo = 1;
					aux->valor = val;
				}
			}
			$$ =  aux;
		}
		| exp_Var '-' exp_Var
		{
			table* aux = NULL;
			if($1 != NULL && $3 != NULL && $1->tipo != 2 && $3->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				val.f = (($1->tipo == 0) ? $1->valor.e : $1->valor.f) - (($3->tipo == 0) ? $3->valor.e : $3->valor.f);
				aux->tipo = 1;
				aux->valor = val;
			}
			$$ =  aux;	
		}
		| exp_Var '*' exp_Var
		{
			table* aux = NULL;
			if($1 != NULL && $3 != NULL && $1->tipo != 2 && $3->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				val.f = (($1->tipo == 0) ? $1->valor.e : $1->valor.f) * (($3->tipo == 0) ? $3->valor.e : $3->valor.f);
				aux->tipo = 1;
				aux->valor = val;
			}
			$$ =  aux;	
		}
		| exp_Var '/' exp_Var
		{
			table* aux = NULL;
			if($1 != NULL && $3 != NULL && $1->tipo != 2 && $3->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				val.f = (($1->tipo == 0) ? $1->valor.e : $1->valor.f) / (($3->tipo == 0) ? $3->valor.e : $3->valor.f);
				aux->tipo = 1;
				aux->valor = val;
			}
			$$ =  aux;	
		}
		| exp_Var '^' exp_Var
		{
			table* aux = NULL;
			if($1 != NULL && $3 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($1->tipo == 2 && $3-> tipo == 0 || $3-> tipo == 1)
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = ($3->tipo == 0) ? $3->valor.e : $3->valor.f;
					for(i = 0; i < fin; i ++)
						resultado = conca($1->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}else
				{
					val.f = pow((($1->tipo == 0) ? $1->valor.e : $1->valor.f),(($3->tipo == 0) ? $3->valor.e : $3->valor.f));
					aux->tipo = 1;
					aux->valor = val;
				}
			}
			$$ =  aux;
		}
		| POTENCIA '(' exp_Var ',' exp_Var ')' ';'
		{
			table* aux = NULL;
			if($3 != NULL && $5 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($3->tipo == 2 && $5-> tipo == 0 || $5-> tipo == 1)
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = ($5->tipo == 0) ? $5->valor.e : $5->valor.f;
					for(i = 0; i < fin; i ++)
						resultado = conca($3->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}else
				{
					val.f = pow((($3->tipo == 0) ? $3->valor.e : $3->valor.f),(($5->tipo == 0) ? $5->valor.e : $5->valor.f));
					aux->tipo = 1;
					aux->valor = val;
				}
			}
			$$ =  aux;
		}

		| exp_Var '+' exp_i
		{
			table* aux = NULL;
			if($1 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($1->tipo == 2)
				{
					char* num = (char*)malloc(sizeof(char)*10);
					char* resultado;
					sprintf(num, "%d", $3);
					resultado = conca($1->valor.s,num);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
				else
					aux = operacion($1,$3,0,0);
			}
			$$ = aux;	
		}
		| exp_i '+' exp_Var
		{
			table* aux = NULL;
			if($3 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($3->tipo == 2)
				{
					char* num = (char*)malloc(sizeof(char)*10);
					char* resultado;
					sprintf(num, "%d", $1);
					resultado = conca(num,$3->valor.s);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
				else
					aux = operacion($3,$1,1,0);
			}
			$$ = aux;	
		}
		| exp_Var '^' exp_i
		{
			table* aux = NULL;
			if($1 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($1->tipo != 2)
					aux = operacion($1,$3,0,4);
				else
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = $3;
					for(i = 0; i < fin; i ++)
						resultado = conca($1->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
			}
			$$ = aux;
		}
		| exp_i '^' exp_Var { $$ = operacion($3,$1,1,4); }
		| POTENCIA '(' exp_Var ',' exp_i ')' ';'
		{
			table* aux = NULL;
			if($3 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($3->tipo != 2)
					aux = operacion($3,$5,0,4);
				else
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = $5;
					for(i = 0; i < fin; i ++)
						resultado = conca($3->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
			}
			$$ = aux;
		}
		| POTENCIA '(' exp_i ',' exp_Var ')' ';' { $$ = operacion($5,$3,1,4); }
		| exp_Var '-' exp_i { $$ = operacion($1,$3,0,1); }
		| exp_i '-' exp_Var { $$ = operacion($3,$1,1,1); }
		| exp_Var '*' exp_i { $$ = operacion($1,$3,0,3); }
		| exp_i '*' exp_Var { $$ = operacion($3,$1,1,3); }
		| exp_Var '/' exp_i { $$ = operacion($1,$3,0,2); }
		| exp_i '/' exp_Var { $$ = operacion($3,$1,1,2); }

		| exp_Var '+' exp_f
		{
			table* aux = NULL;
			if($1 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($1->tipo == 2)
				{
					char* num = (char*)malloc(sizeof(char)*10);
					char* resultado;
					sprintf(num, "%g", $3);
					resultado = conca($1->valor.s,num);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
				else
					aux = operacion($1,$3,0,0);
			}
			$$ = aux;	
		}
		| exp_f '+' exp_Var
		{
			table* aux = NULL;
			if($3 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($3->tipo == 2)
				{
					char* num = (char*)malloc(sizeof(char)*10);
					char* resultado;
					sprintf(num, "%g", $1);
					resultado = conca(num,$3->valor.s);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
				else
					aux = operacion($3,$1,1,0);
			}
			$$ = aux;	
		}
		| exp_Var '^' exp_f
		{
			table* aux = NULL;
			if($1 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($1->tipo != 2)
					aux = operacion($1,$3,0,4);
				else
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = $3;
					for(i = 0; i < fin; i ++)
						resultado = conca($1->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
			}
			$$ = aux;
		}
		| exp_f '^' exp_Var { $$ = operacion($3,$1,1,4); }
		| POTENCIA '(' exp_Var ',' exp_f ')' ';'
		{
			table* aux = NULL;
			if($3 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				if($3->tipo != 2)
					aux = operacion($3,$5,0,4);
				else
				{
					char* resultado = (char*)malloc(sizeof(char)*1);
					resultado[0] = '\n';
					int i,fin = $5;
					for(i = 0; i < fin; i ++)
						resultado = conca($3->valor.s,resultado);
					val.s = resultado;
					aux->tipo = 2;
					aux->valor = val;
				}
			}
			$$ = aux;
		}
		| POTENCIA '(' exp_f ',' exp_Var ')' ';' { $$ = operacion($5,$3,1,4); }
		| exp_Var '-' exp_f { $$ = operacion($1,$3,0,1); }
		| exp_f '-' exp_Var { $$ = operacion($3,$1,1,1); }
		| exp_Var '*' exp_f { $$ = operacion($1,$3,0,3); }
		| exp_f '*' exp_Var { $$ = operacion($3,$1,1,3); }
		| exp_Var '/' exp_f { $$ = operacion($1,$3,0,2); }
		| exp_f '/' exp_Var { $$ = operacion($3,$1,1,2); }

		| exp_Var '+' exp_c
		{
			table* aux = NULL;
			if($1 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				char* resultado;
				if($1->tipo == 2)
					resultado = conca($1->valor.s,$3);
				else
				{
					char* num = (char*)malloc(sizeof(char)*10);
					sprintf(num, "%g", ($1->tipo == 0) ? $1->valor.e : $1->valor.f);
					resultado = conca(num,$3);
				}	
				val.s = resultado;
				aux->tipo = 2;
				aux->valor = val;
			}
			$$ = aux;
		}
		| exp_c '+' exp_Var
		{
			table* aux = NULL;
			if($3 != NULL)
			{
				aux = (table*)malloc(sizeof(table));
				char* resultado;
				if($3->tipo == 2)
					resultado = conca($1,$3->valor.s);
				else
				{
					char* num = (char*)malloc(sizeof(char)*10);
					sprintf(num, "%g", ($3->tipo == 0) ? $3->valor.e : $3->valor.f);
					resultado = conca($1,num);
				}	
				val.s = resultado;
				aux->tipo = 2;
				aux->valor = val;
			}
			$$ = aux;	
		}
		| exp_c '^' exp_Var
		{
			table* aux = NULL;
			if($3 != NULL && $3->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				char* resultado = (char*)malloc(sizeof(char)*1);
				resultado[0] = '\n';
				int i,fin = ($3->tipo == 0) ? $3->valor.e : $3->valor.f;
				for(i = 0; i < fin; i ++)
					resultado = conca($1,resultado);
				val.s = resultado;
				aux->tipo = 2;
				aux->valor = val;
			}
			$$ =  aux;
		}
		| POTENCIA '(' exp_c ',' exp_Var ')' ';'
		{
			table* aux = NULL;
			if($5 != NULL && $5->tipo != 2)
			{
				aux = (table*)malloc(sizeof(table));
				char* resultado = (char*)malloc(sizeof(char)*1);
				resultado[0] = '\n';
				int i,fin = ($5->tipo == 0) ? $5->valor.e : $5->valor.f;
				for(i = 0; i < fin; i ++)
					resultado = conca($3,resultado);
				val.s = resultado;
				aux->tipo = 2;
				aux->valor = val;
			}
			$$ =  aux;
		}
		| exp_Var '-' exp_c { $$ = NULL; }
		| exp_c '-' exp_Var { $$ = NULL; }
		| exp_Var '*' exp_c { $$ = NULL; }
		| exp_c '*' exp_Var { $$ = NULL; }
		| exp_Var '/' exp_c { $$ = NULL; }
		| exp_c '/' exp_Var { $$ = NULL; }
		| exp_Var '^' exp_c { $$ = NULL; }
		| POTENCIA '(' exp_Var ',' exp_c ')' ';'{ $$ = NULL; }
;

%%

int main()
{
	yyparse();
}

yyerror (char *s)
{
	printf("\t\e[91m%s\e[0m\n",s);
}

int yywrap()
{
	return 1;
}
