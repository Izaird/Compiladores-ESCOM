%{
	#include <stdio.h>
	#include <stdlib.h>	
	#include <math.h>
	#include "Tabla_simbolos.h"
%}

/*Declaraciones de Bison*/
%union{
	int entero;
	float flotante;
	char* cadena;
}

%token <entero> ENTERO
%token <flotante> REAL
%token <cadena> CADENA
%token <cadena> VARIABLE
%token IF INT FLOAT POTENCIA
%type <entero> exp_i
%type <flotante> exp_f
%type <cadena> exp_c
%type <flotante> exp_Var

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
	| exp_Var '\n' { printf("\tResultado: %.4g\n\n", $1); }
	
	/** Manejo de variables **/
		/** Manejo de variables enteras **/
	|VARIABLE ';'
	{
		char* temp = (char*)malloc(sizeof(char)*size($1));
		int i = 0;
		while($1[i] != 32 && $1[i] != 10 && $1[i] != 9 && $1[i] != ';')
		{
			temp[i] = $1[i];
			i ++;
		}
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 0)
				printf("\tResultado: %s = %d\n",aux->lexema,aux->valor_e);
			else
				printf("\tResultado: %s = %f\n",aux->lexema,aux->valor_f);
		}
		else
			printf("\t\e[35mVariable no declarada\e[0m\n");
	}
	| INT VARIABLE ';'
	{
		char* temp = (char*)malloc(sizeof(char)*size($2));
		for(int i = 0; i < size($2) - 1; i ++)
			temp[i] = $2[i];
		/*val.e = 0;
		val.f = 0;
		if(add(temp,0,val) == false)*/
		if(add(temp,0,0,0) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = 0\n",temp);
	}
	| INT VARIABLE '=' exp_i';'
	{
		char* temp = (char*)malloc(sizeof(char)*size($2));
		int i = 0;
		while($2[i] != 32 && $2[i] != 10 && $2[i] != 9 && $2[i] != '=')
		{
			temp[i] = $2[i];
			i ++;
		}
		/*val.e = $4;
		val.f = 0;
		if(add(temp,0,val) == false)*/
		if(add(temp,0,$4,0) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %d\n",temp,$4);
	}
	| VARIABLE '=' exp_i ';'
	{
		char* temp = (char*)malloc(sizeof(char)*size($1));
		int i = 0;
		while($1[i] != 32 && $1[i] != 10 && $1[i] != 9)
		{
			temp[i] = $1[i];
			i ++;
		}
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 0)
			{
				/*val.e = $3;
				val.f = 0;
				aux->valor = val;*/
				aux->valor_e = $3;
				aux->valor_f = 0;
				printf("\tResultado: %s = %d\n",temp,aux->valor_e);
			}
			else
			{	
				/*val.e = 0;
				val.f = $3;
				aux->valor = val;*/
				aux->valor_e = 0;
				aux->valor_f = $3;
				printf("\tResultado: %s = %g\n",temp,aux->valor_f);
			}
		}
		else
			printf("\t\e[35mVariable no declarada\e[0m\n");
	}

		/** Manejo de variables flotantes **/
	| FLOAT VARIABLE ';'
	{
		char* temp = (char*)malloc(sizeof(char)*size($2));
		for(int i = 0; i < size($2) - 1; i ++)
			temp[i] = $2[i];
		/*val.f = 0;
		val.e = 0;
		if(add(temp,1,val) == false)*/
		if(add(temp,1,0,0) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = 0\n",temp);
	}
	| FLOAT VARIABLE '=' exp_f';'
	{
		char* temp = (char*)malloc(sizeof(char)*size($2));
		int i = 0;
		while($2[i] != 32 && $2[i] != 10 && $2[i] != 9 && $2[i] != '=')
		{
			temp[i] = $2[i];
			i ++;
		}
		/*val.f = $4;
		val.e = 0;
		if(add(temp,1,val) == false)*/
		if(add(temp,1,0,$4) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %g\n",temp,$4);
	}
	| FLOAT VARIABLE '=' exp_i';'
	{
		char* temp = (char*)malloc(sizeof(char)*size($2));
		int i = 0;
		while($2[i] != 32 && $2[i] != 10 && $2[i] != 9  && $2[i] != '=')
		{
			temp[i] = $2[i];
			i ++;
		}
		/*val.f = $4;
		val.e = 0;
		if(add(temp,1,val) == false)*/
		if(add(temp,1,0,$4) == false)
			printf("\t\e[35mVariable previamente declarada\e[0m\n");
		else
			printf("\tResultado: %s = %d\n",temp,$4);
	}
	| VARIABLE '=' exp_f ';'
	{
		char* temp = (char*)malloc(sizeof(char)*size($1));
		int i = 0;
		while($1[i] != 32 && $1[i] != 10 && $1[i] != 9  && $1[i] != '=')
		{
			temp[i] = $1[i];
			i ++;
		}
		table* aux =  get_nodo(temp);
		/*val.e = 0;
		val.f = $3;*/
		if(aux != NULL)
		{
			if(aux->tipo == 1)
			{
				aux->valor_f = $3;
				printf("\tResultado: %s = %f\n",temp,aux->valor_f);
			}
			else
			{	
				printf("\t\e[35mTipo de dato incompatible\e[0m\n");
			}
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
		int size = 0,i,j,apuntador = 0;
		while($1[size]){ size ++; }
		char *aux = (char*)malloc(sizeof(char)*(size*$3));
		for(i = 0; i < $3; i++)
			for(j = 0; j < size; j ++)
			{
				aux[apuntador] = $1[j];
				apuntador ++;
			}
		aux[$3*size] = '\0';
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
		char* temp = (char*)malloc(sizeof(char)*size($1));
		for(int i = 0; i < size($1) - 1; i ++)
			temp[i] = $1[i];
		table* aux =  get_nodo(temp);
		if(aux != NULL)
		{
			if(aux->tipo == 0)
				$$ = aux->valor_e;
			else
				$$ = aux->valor_f;
		}
		else
		{
			printf("\t\e[35mVariable no declarada\e[0m\n");
			$$ = 0.00000;
		}
	}
	| '(' exp_Var ')'
	{
		$$ = $2;
	}
	
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
