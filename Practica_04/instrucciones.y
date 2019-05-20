%{
#include <stdio.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

extern int yylex(void);

%}

//-----------------------------------------------------------------------------------------
//Definimos los tokens producidos por yylex() 
//-----------------------------------------------------------------------------------------
%union{
	int entero;
	double flotante;
	char* string;
}
%token <entero> ENTERO
%type <entero> exp term
%token <flotante> RACIONAL
%type <flotante> expf termf
%token <string> CADENA
%type <string> exp_str
%left '+' '-'
%left '*' '/'
%left NEGATIVE
%left COS EXP SIN SQRT TAN POW



//-----------------------------------------------------------------------------------------
//Comenzamos con la definicion del parser
//-----------------------------------------------------------------------------------------

%%

//-----------------------------------------------------------------------------------------
//Una linea puede estar vacia, contener espacioes en blanco o contener expresiones
//-----------------------------------------------------------------------------------------
input:    /* cadena vacía */
        | input line             
;

line:     '\n'
        | exp '\n'  { printf ("\tresultado: %d\n", $1); }
        | expf '\n'  { printf ("\tresultado: %.8g\n", $1); }
        | exp_str '\n' { printf("\tresultado: %s\n", $1); }
;
//-----------------------------------------------------------------------------------------
//Las expresiones son definidas recursivamente como cadenas de terminos
//y expresiones. 
//-----------------------------------------------------------------------------------------


exp:  term					{ $$ = $1;         	}
    |     exp '+' exp				{ $$ = $1 + $3;    	}
    |     exp '-' exp				{ $$ = $1 - $3;    	}
    |     exp '*' exp				{ $$ = $1 * $3;    	}
    |     exp '/' exp				{ $$ = $1 / $3;    	}
    |     '-' exp  %prec NEGATIVE		{ $$ = - $2;       	}
    |     COS   term				{ $$ = cos($2);    	}
    |     EXP   term				{ $$ = exp($2);    	}
    |     SIN   term				{ $$ = sin($2);    	}
    |     SQRT  term				{ $$ = sqrt($2);   	}
    |     TAN   term				{ $$ = tan($2);    	} 
    |     POW   '(' term ',' term ')'';' 	{ $$ = pow($3,$5); 	}
    ;


expf:  termf					{ $$ = $1;         	}
    |     expf '+' expf				{ $$ = $1 + $3;    	}
    |     expf '+' exp				{ $$ = $1 + $3;    	}
    |     exp  '+' expf				{ $$ = $1 + $3;    	}
    |     expf '-' expf				{ $$ = $1 - $3;    	}
    |     expf '-' exp				{ $$ = $1 - $3;    	}
    |     exp  '-' expf				{ $$ = $1 - $3;    	}
    |     expf '*' expf				{ $$ = $1 * $3;    	}
    |     expf '*' exp 				{ $$ = $1 * $3;    	}
    |     exp  '*' expf				{ $$ = $1 * $3;    	}
    |     expf '/' expf				{ $$ = $1 / $3;    	}
    |     expf '/' exp				{ $$ = $1 / $3;    	}
    |     exp  '/' expf				{ $$ = $1 / $3;    	}
    |     '-' expf  %prec NEGATIVE		{ $$ = - $2;       	}
    |     COS   termf				{ $$ = cos($2);    	}
    |     EXP   termf				{ $$ = exp($2);    	}
    |     SIN   termf				{ $$ = sin($2);    	}
    |     SQRT  termf				{ $$ = sqrt($2);   	}
    |     TAN   termf				{ $$ = tan($2);    	} 
    |     POW   '(' termf ',' termf ')' ';'	{ $$ = pow($3,$5); 	}
    |     POW   '(' termf ',' term ')' ';'	{ $$ = pow($3,$5); 	}
    |     POW   '(' term ',' termf ')' ';'	{ $$ = pow($3,$5); 	}
    ;



//-----------------------------------------------------------------------------------------
// Se tiene que especificar lo siguiente para los tokens con mayor precedencia
// puedan ser distinguidos correctamente y cosas como pow() funcionen
//-----------------------------------------------------------------------------------------

termf:     RACIONAL				{ $$ = $1;         	}
    |     '(' expf ')'				{ $$ = $2;         	}
    ;


term:     ENTERO				{ $$ = $1;         	}
    |     '(' exp ')'				{ $$ = $2;        	}
    ;


exp_str: CADENA 				{ $$ = $1;		}
  | exp_str '+' exp_str  			{ $$ = strcat($1,$3);	}
;
%%



#include <stdlib.h>
#include <string.h>
#include <unistd.h>
int lineno;


char *fname = "-stdin-";
int yyerror(const char *s)
{
    fprintf(stderr,"%s(%d):%s\n",fname,lineno,s);
    return 0;
}

main()

{

	yyparse();

	return 0;

}

