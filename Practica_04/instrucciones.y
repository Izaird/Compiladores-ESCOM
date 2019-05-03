%{
#include <stdio.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#define YYSTYPE double
YYSTYPE last_value = 0;

extern int yylex(void);

%}

//-----------------------------------------------------------------------------------------
//Definimos los tokens producidos por yylex() 
//-----------------------------------------------------------------------------------------
%union{
	int entero;
  float flotante;
  char* string;
}
%token <entero> ENTERO
%type <entero> exp term
%token <flotante> FLOTANTE
%type <flotante> expf
%token <string> CADENA
%type <string> exp_str
%token LAST
%left '+' '-'
%left '*' '/'
%left NEGATIVE
%left COS EXP SIN SQRT TAN POW



//-----------------------------------------------------------------------------------------
//Comenzamos con la definicion del parser
//-----------------------------------------------------------------------------------------

%%

//-----------------------------------------------------------------------------------------
//Una lista puede estar vacia, contener espacioes en blanco o contener expresiones
//-----------------------------------------------------------------------------------------
list:

    |    list '\n'
    |    list exp '\n'           { printf("%.8g\n",last_value=$2);}
    ; 
//-----------------------------------------------------------------------------------------
//Las expresiones son definidas recursivamente como cadenas de terminos
//y expresiones. 
//-----------------------------------------------------------------------------------------


    exp:     term                        { $$ = $1;         }
    |     exp '+' exp                   { $$ = $1 + $3;    }
    |     exp '-' exp                   { $$ = $1 - $3;    }
    |     exp '*' exp                   { $$ = $1 * $3;    }
    |     exp '/' exp                   { $$ = $1 / $3;    }
    |     '-' exp  %prec NEGATIVE        { $$ = - $2;       }
    |     COS   term                      { $$ = cos($2);    }
    |     EXP   term                      { $$ = exp($2);    }
    |     SIN   term                      { $$ = sin($2);    }
    |     SQRT  term                      { $$ = sqrt($2);   }
    |     TAN   term                      { $$ = tan($2);    } 
    |     POW   '(' term ',' term ')' ';' { $$ = pow($3,$5); }
    ;


//-----------------------------------------------------------------------------------------
// Se tiene que especificar lo siguiente para los tokens con mayor precedencia
// necesitan ser distinguidos para que operaciones como pow()
// puedan funcionar correctamente
//-----------------------------------------------------------------------------------------


term:     ENTERO                   { $$ = $1;         }
    |     LAST                     { $$ = last_value; }
    |     '(' exp ')'             { $$ = $2;         }
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

