%{
#include <stdio.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "cadenas_op.h"
#include "tabla_sim.h"
%}

/*Declaraciones de Bison*/
%union{
	struct table* Tabla_S;
	int entero;
	double flotante;
	char* cadena;
}

%token <entero> ENTERO
%type <entero> exp_i term
%token <flotante> RACIONAL
%type <flotante> exp_f termf
%token <cadena> CADENA
%type <cadena> exp_c
%token <cadena> VARIABLE
%token IF INT FLOAT STRING POW
%type <Tabla_S> exp_Var
%left '+' '-'
%left '*' '/' 
%left NEGATIVE
%left POW '^' 

/* Gramaticas */
%%

input:	/* Cadena vacia */
		| input line
;

line: '\n'

	/** Manejo de constantes **/
	| exp_i '\n' 					{printf("\tResultado: %d\n\n", $1); }
	| exp_f '\n' 					{printf("\tResultado: %.8g\n\n", $1); }
	| exp_c '\n' 					{printf("\tResultado: %s\n\n", $1); }
	| exp_Var '\n'					{print_var($1);}
	| exp_Var ';' '\n'				{print_var($1);}
//-----------------------------------------------------------------------------------------
//Declaracion de variables numericas
//-----------------------------------------------------------------------------------------
	| INT VARIABLE ';'				{declaration_var($2,0,0);}
	| INT VARIABLE '=' exp_i';'		{declaration_var($2,$4,0);}
	| FLOAT VARIABLE ';'			{declaration_var($2,0,1);}
	| FLOAT VARIABLE '=' exp_f';'	{declaration_var($2,$4,1);}
	| FLOAT VARIABLE '=' exp_i';'	{declaration_var($2,$4,1);}
//-----------------------------------------------------------------------------------------
//Cambio de valor de una variable numericas previamente declarada
//-----------------------------------------------------------------------------------------
	| VARIABLE '=' exp_i ';'		{change_val($1,$3,0);}
	| VARIABLE '=' exp_f ';'		{change_val($1,$3,1);}
//-----------------------------------------------------------------------------------------
//Declaracion de variables tipo cadena
//-----------------------------------------------------------------------------------------
	| STRING VARIABLE ';'			{declaration_var_s($2,0);}
	| STRING VARIABLE'='exp_c ';'	{declaration_var_s($2,$4);}
//-----------------------------------------------------------------------------------------
//Cambio de valor de variable tipo cadena
//-----------------------------------------------------------------------------------------
	| VARIABLE '=' exp_c ';'		{change_val_s($1,$3);}

//-----------------------------------------------------------------------------------------
//Condicionales
//-----------------------------------------------------------------------------------------
	| IF '(' exp_i '>' exp_i ')' ';' '\n' { 
		if($3 > $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_i '<' exp_i ')' ';' '\n' { 
		if($3 < $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_f '>' exp_i ')' ';' '\n' { 
		if($3 > $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_f '<' exp_i ')' ';' '\n' { 
		if($3 < $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_i '>' exp_f ')' ';' '\n' { 
		if($3 > $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_i '<' exp_f ')' ';' '\n' { 
		if($3 < $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_f '>' exp_f ')' ';' '\n' { 
		if($3 > $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
	| IF '(' exp_f '<' exp_f ')' ';' '\n' { 
		if($3 < $5)
			printf("\tTRUE\n\n");
		else
			printf("\tFALSE\n\n");
	}
;

//-----------------------------------------------------------------------------------------
//Expresiones con numeros enteros
//-----------------------------------------------------------------------------------------
exp_i:  term					{ $$ = $1;         	}
    |     exp_i '+' exp_i				{ $$ = $1 + $3;    	}
    |     exp_i '-' exp_i				{ $$ = $1 - $3;    	}
    |     exp_i '*' exp_i				{ $$ = $1 * $3;    	}
    |     exp_i '/' exp_i				{ $$ = $1 / $3;    	}
    |     '-' exp_i  %prec NEGATIVE		{ $$ = - $2;       	}
    |     POW   '(' term ',' term ')'';' 	{ $$ = pow($3,$5); 	}
    ;

//-----------------------------------------------------------------------------------------
//Expresiones con numeros racionales
//-----------------------------------------------------------------------------------------
exp_f:  termf								{ $$ = $1;         	}
    |     exp_f '+' exp_f					{ $$ = $1 + $3;    	}
    |     exp_f '+' exp_i					{ $$ = $1 + $3;    	}
    |     exp_i  '+' exp_f					{ $$ = $1 + $3;    	}
    |     exp_f '-' exp_f					{ $$ = $1 - $3;    	}
    |     exp_f '-' exp_i					{ $$ = $1 - $3;    	}
    |     exp_i  '-' exp_f					{ $$ = $1 - $3;    	}
    |     exp_f '*' exp_f					{ $$ = $1 * $3;    	}
    |     exp_f '*' exp_i 					{ $$ = $1 * $3;    	}
    |     exp_i  '*' exp_f					{ $$ = $1 * $3;    	}
    |     exp_f '/' exp_f					{ $$ = $1 / $3;    	}
    |     exp_f '/' exp_i					{ $$ = $1 / $3;    	}
    |     exp_i  '/' exp_f					{ $$ = $1 / $3;    	}
    |     '-' exp_f  %prec NEGATIVE			{ $$ = - $2;       	}
    |     POW   '(' termf ',' termf ')' ';'	{ $$ = pow($3,$5); 	}
    |     POW   '(' termf ',' term ')' ';'	{ $$ = pow($3,$5); 	}
    |     POW   '(' term ',' termf ')' ';'	{ $$ = pow($3,$5); 	}
    ;

//-----------------------------------------------------------------------------------------
// Se tiene que especificar lo siguiente para los tokens con mayor precedencia
// puedan ser distinguidos correctamente y cosas como pow() funcionen
//-----------------------------------------------------------------------------------------

termf:     RACIONAL							{ $$ = $1;         	}
    |     '(' exp_f ')'						{ $$ = $2;         	}
    ;


term:     ENTERO							{ $$ = $1;         	}
    |     '(' exp_i ')'						{ $$ = $2;        	}
    ;



/** Expresion que usa cadenas **/
exp_c: CADENA {	$$ = $1; }
	| '(' exp_c ')'	{ $$ = $2; }
	| exp_c '+' exp_c						{$$ = conca($1,$3);}
	| exp_c '^' exp_i						{
		char* aux = (char*)malloc(sizeof(char)*1);
		aux[0] = '\n';
		int i;
		for(i = 0; i < $3; i ++)
			aux = conca($1,aux);
		$$ = aux;
	}
	| POW '(' exp_c ',' exp_i ')' ';'
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
		| POW '(' exp_Var ',' exp_Var ')' ';'
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
		| POW '(' exp_Var ',' exp_i ')' ';'
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
		| POW '(' exp_i ',' exp_Var ')' ';' { $$ = operacion($5,$3,1,4); }
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
		| POW '(' exp_Var ',' exp_f ')' ';'
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
		| POW '(' exp_f ',' exp_Var ')' ';' { $$ = operacion($5,$3,1,4); }
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
		| POW '(' exp_c ',' exp_Var ')' ';'
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
		| POW '(' exp_Var ',' exp_c ')' ';'{ $$ = NULL; }
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
