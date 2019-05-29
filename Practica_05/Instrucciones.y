%{
#define true 1
#define false 0
#include <stdio.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "cadenas_op.h"
#include "tabla_sim.h"
#include "variables.h"
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
%token IF INT FLOAT STRING POW TABLA
%type <Tabla_S> exp_Var
%left '+' '-'
%left '*' '/' 
%left NEGATIVE
%left POW '^' 

//-----------------------------------------------------------------------------------------
//Comenzamos con la definicion del parser
//-----------------------------------------------------------------------------------------
%%



//-----------------------------------------------------------------------------------------
//Una linea puede estar vacia, contener espacioes en blanco o contener expresiones
//-----------------------------------------------------------------------------------------
input:	/* Cadena vacia */
		| input line
;

line: '\n'
//-----------------------------------------------------------------------------------------
// Impresion de expresiones
//-----------------------------------------------------------------------------------------	
| exp_i '\n' 							{printf("\tResultado: %d\n\n", $1); }
| exp_f '\n' 							{printf("\tResultado: %.8g\n\n", $1); }
| exp_c '\n' 							{printf("\tResultado: %s\n\n", $1); }
| exp_Var '\n'							{print_var($1);}
| exp_Var ';' '\n'						{print_var($1);}
| VARIABLE ';'							{print_var_lit($1);}
//-----------------------------------------------------------------------------------------
//Declaracion de variables numericas
//-----------------------------------------------------------------------------------------
| INT VARIABLE ';'						{declaration_var($2,0,0);}
| INT VARIABLE '=' exp_i';'					{declaration_var($2,$4,0);}
| FLOAT VARIABLE ';'						{declaration_var($2,0,1);}
| FLOAT VARIABLE '=' exp_f';'					{declaration_var($2,$4,1);}
| FLOAT VARIABLE '=' exp_i';'					{declaration_var($2,$4,1);}
//-----------------------------------------------------------------------------------------
//Cambio de valor de una variable numericas previamente declarada
//-----------------------------------------------------------------------------------------
| VARIABLE '=' exp_Var ';'					{asign_val($1,$3);}	
| VARIABLE '=' exp_i ';'					{change_val($1,$3,0);}
| VARIABLE '=' exp_f ';'					{change_val($1,$3,1);}
//-----------------------------------------------------------------------------------------
//Declaracion de variables tipo cadena
//-----------------------------------------------------------------------------------------
| STRING VARIABLE ';'						{declaration_var_s($2,0);}
| STRING VARIABLE'='exp_c ';'					{declaration_var_s($2,$4);}
//-----------------------------------------------------------------------------------------
//Cambio de valor de variable tipo cadena
//-----------------------------------------------------------------------------------------
| VARIABLE '=' exp_c ';'					{change_val_s($1,$3);}

//-----------------------------------------------------------------------------------------
//Condicionales
//-----------------------------------------------------------------------------------------
| IF '(' exp_i '>' exp_i ')' ';' '\n' { ($3 > $5)?	printf("\tTRUE\n\n") : printf("\tFALSE\n\n");}
| IF '(' exp_i '<' exp_i ')' ';' '\n' { ($3 < $5)?	printf("\tTRUE\n\n") : printf("\tFALSE\n\n");}
| IF '(' exp_f '>' exp_i ')' ';' '\n' { ($3 > $5)?	printf("\tTRUE\n\n") : printf("\tFALSE\n\n");}
| IF '(' exp_f '<' exp_i ')' ';' '\n' { ($3 < $5)?	printf("\tTRUE\n\n") : printf("\tFALSE\n\n");}
| IF '(' exp_i '>' exp_f ')' ';' '\n' { ($3 > $5)?	printf("\tTRUE\n\n") : printf("\tFALSE\n\n");}
| IF '(' exp_i '<' exp_f ')' ';' '\n' { ($3 < $5)?	printf("\tTRUE\n\n") : printf("\tFALSE\n\n");}
| IF '(' exp_f '>' exp_f ')' ';' '\n' { ($3 > $5)?	printf("\tTRUE\n\n") : printf("\tFALSE\n\n");}
| IF '(' exp_f '<' exp_f ')' ';' '\n' { ($3 < $5)?	printf("\tTRUE\n\n") : printf("\tFALSE\n\n");}
| IF '(' exp_Var '>' exp_Var ')' ';' '\n' {var_comp($3,$5);}
| IF '(' exp_Var '<' exp_Var ')' ';' '\n'	{var_comp($5,$3);}
| TABLA			'\n'	{mostrar();}
;

//-----------------------------------------------------------------------------------------
//Expresiones con numeros enteros
//-----------------------------------------------------------------------------------------
exp_i:  term										{ $$ = $1;         	}
| exp_i '+' exp_i						{ $$ = $1 + $3;    	}
| exp_i '-' exp_i						{ $$ = $1 - $3;    	}
| exp_i '*' exp_i						{ $$ = $1 * $3;    	}
| exp_i '/' exp_i						{ $$ = $1 / $3;    	}
| '-' exp_i  %prec NEGATIVE					{ $$ = - $2;       	}
| POW   '(' term ',' term ')'';'				{ $$ = pow($3,$5); 	}
;

//-----------------------------------------------------------------------------------------
//Expresiones con numeros racionales
//-----------------------------------------------------------------------------------------
exp_f:  termf										{ $$ = $1;         	}
| exp_f '+' exp_f						{ $$ = $1 + $3;    	}
| exp_f '+' exp_i						{ $$ = $1 + $3;    	}
| exp_i  '+' exp_f						{ $$ = $1 + $3;    	}
| exp_f '-' exp_f						{ $$ = $1 - $3;    	}
| exp_f '-' exp_i						{ $$ = $1 - $3;    	}
| exp_i  '-' exp_f						{ $$ = $1 - $3;    	}
| exp_f '*' exp_f						{ $$ = $1 * $3;    	}
| exp_f '*' exp_i 						{ $$ = $1 * $3;    	}
| exp_i  '*' exp_f						{ $$ = $1 * $3;    	}
| exp_f '/' exp_f						{ $$ = $1 / $3;    	}
| exp_f '/' exp_i						{ $$ = $1 / $3;    	}
| exp_i  '/' exp_f						{ $$ = $1 / $3;    	}
| '-' exp_f  %prec NEGATIVE					{ $$ = - $2;       	}
| POW   '(' termf ',' termf ')' ';'				{ $$ = pow($3,$5); 	}
| POW   '(' termf ',' term ')' ';'				{ $$ = pow($3,$5); 	}
| POW   '(' term ',' termf ')' ';'				{ $$ = pow($3,$5); 	}
;

//-----------------------------------------------------------------------------------------
// Se tiene que especificar lo siguiente para los tokens con mayor precedencia
// puedan ser distinguidos correctamente y cosas como pow() funcionen
//-----------------------------------------------------------------------------------------

termf:     RACIONAL						{ $$ = $1;         	}
| '(' exp_f ')'							{ $$ = $2;         	}
;


term:     ENTERO						{ $$ = $1;         	}
| '(' exp_i ')'							{ $$ = $2;        	}
;



//-----------------------------------------------------------------------------------------
//Expresiones con cadenas
//-----------------------------------------------------------------------------------------
exp_c: CADENA {	$$ = $1; }
| '(' exp_c ')'							{ $$ = $2; }
| exp_c '+' exp_c						{ $$ = conca($1,$3);}
| exp_c '^' exp_i						{ $$ = pow_s($1,$3);}
| POW '(' exp_c ',' exp_i ')' ';'				{ $$ = pow_s($3,$5);}
| exp_c '+' exp_i						{ $$ = conca_i($1,$3);}
| exp_i '+' exp_c						{ $$ = conca_i($3,$1);}
| exp_c '+' exp_f						{ $$ = conca_f($1,$3);}
| exp_f '+' exp_c						{ $$ = conca_f($3,$1);}
;

//Guardamos el nodo 
exp_Var: VARIABLE						{$$ =var_to_expvar($1);}

| '(' exp_Var ')'				{ $$ = $2;	}

//-----------------------------------------------------------------------------------------
//Expresiones con variables
//-----------------------------------------------------------------------------------------
| exp_Var '+' exp_Var						{$$ = add_var($1,$3);}
| exp_Var '-' exp_Var						{$$ = sub_var($1,$3);}
| exp_Var '*' exp_Var						{$$ = mul_var($1,$3);}
| exp_Var '/' exp_Var						{$$ = div_var($1,$3);}
| exp_Var '^' exp_Var						{$$ = pow_var($1,$3);}
| POW '(' exp_Var ',' exp_Var ')' ';'				{$$ = pow_var($3,$5);}
//-----------------------------------------------------------------------------------------
//Expresiones con variables y reales
//-----------------------------------------------------------------------------------------
| exp_Var '+' exp_i						{$$ = add_var_i($1,$3,0);}
| exp_i '+' exp_Var						{$$ = add_var_i($3,$1,1);}
| exp_Var '+' exp_f						{$$ = add_var_f($1,$3,0);}
| exp_f '+' exp_Var						{$$ = add_var_f($3,$1,1);}
| exp_Var '-' exp_i 						{ $$ = operacion($1,$3,0,1); }
| exp_i '-' exp_Var 						{ $$ = operacion($3,$1,1,1); }
| exp_Var '/' exp_i 						{ $$ = operacion($1,$3,0,2); }
| exp_i '/' exp_Var 						{ $$ = operacion($3,$1,1,2); }
| exp_Var '*' exp_i 						{ $$ = operacion($1,$3,0,3); }
| exp_i '*' exp_Var 						{ $$ = operacion($3,$1,1,3); }
| exp_Var '^' exp_i						{$$ = pow_var_i($1,$3,0);}
| exp_i '^' exp_Var 						{$$ = pow_var_i($3,$1,1);}
| POW '(' exp_Var ',' exp_i ')' ';'				{$$ = pow_var_i($3,$5,0);}
| POW '(' exp_i ',' exp_Var ')' ';' 				{$$ = pow_var_i($5,$3,1);}		
| exp_Var '-' exp_f 						{ $$ = operacion($1,$3,0,1); }
| exp_f '-' exp_Var 						{ $$ = operacion($3,$1,1,1); }
| exp_Var '/' exp_f 						{ $$ = operacion($1,$3,0,2); }
| exp_f '/' exp_Var 						{ $$ = operacion($3,$1,1,2); }
| exp_Var '*' exp_f 						{ $$ = operacion($1,$3,0,3); }
| exp_f '*' exp_Var 						{ $$ = operacion($3,$1,1,3); }
| exp_Var '^' exp_f						{ $$ = operacion($1,$3,0,4); }
| exp_f '^' exp_Var 						{ $$ = operacion($3,$1,1,4); }
| POW '(' exp_Var ',' exp_f ')' ';'				{ $$ = operacion($3,$5,0,4); }
| POW '(' exp_f ',' exp_Var ')' ';' 				{ $$ = operacion($5,$3,1,4); }
//-----------------------------------------------------------------------------------------
//Expresiones con variables y cadenas
//-----------------------------------------------------------------------------------------
| exp_Var '+' exp_c						{ $$= add_var_s($1,$3);}
| exp_c '+' exp_Var						{ $$= add_var_s($3,$1);}
| exp_c '^' exp_Var						{ $$= pow_var_s($3,$1);}
| POW '(' exp_c ',' exp_Var ')' ';'				{ $$= pow_var_s($5,$3);}
| exp_Var '-' exp_c	 					{ $$ = NULL; }
| exp_c '-' exp_Var 						{ $$ = NULL; }
| exp_Var '*' exp_c 						{ $$ = NULL; }
| exp_c '*' exp_Var 						{ $$ = NULL; }
| exp_Var '/' exp_c						{ $$ = NULL; }
| exp_c '/' exp_Var 						{ $$ = NULL; }
| exp_Var '^' exp_c 						{ $$ = NULL; }
| POW '(' exp_Var ',' exp_c ')' ';'				{ $$ = NULL; }
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
