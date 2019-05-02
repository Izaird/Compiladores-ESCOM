%{

#include <stdio.h>
#include <math.h>
#define YYSTYPE double
YYSTYPE last_value = 0;

extern int yylex(void);

%}

//-----------------------------------------------------------------------------------------
//Definimos los tokens producidos por yylex() 
//-----------------------------------------------------------------------------------------

%token NUMBER
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
    |    list expr '\n'           { printf("%.8g\n",last_value=$2);}
    ; 
//-----------------------------------------------------------------------------------------
//Las expresiones son definidas recursivamente como cadenas de terminos
//y expresiones. 
//-----------------------------------------------------------------------------------------


    expr:     term                        { $$ = $1;         }
    |     expr '+' expr                   { $$ = $1 + $3;    }
    |     expr '-' expr                   { $$ = $1 - $3;    }
    |     expr '*' expr                   { $$ = $1 * $3;    }
    |     expr '/' expr                   { $$ = $1 / $3;    }
    |     '-' expr  %prec NEGATIVE        { $$ = - $2;       }
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


term:     NUMBER                   { $$ = $1;         }
    |     LAST                     { $$ = last_value; }
    |     '(' expr ')'             { $$ = $2;         }
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

