%{
//#include <math.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
char* stringconcat( char *s1,  char *s2);
%}
             
/* Declaraciones de BISON */
%union{
	int entero;
  float flotante;
  char* string;
}
%token <entero> ENTERO
%type <entero> exp
%token <flotante> FLOTANTE
%type <flotante> expf
%token <string> CADENA
%type <string> exp_str
%token POW
%left '+' '-'
%left '*' "/"
             
/* Gramática */
%%
             
input:    /* cadena vacía */
        | input line             
;

line:     '\n'
        | exp '\n'  { printf ("\tresultado: %d\n", $1); }
        | expf '\n'  { printf ("\tresultado: %f\n", $1); }
        | exp_str '\n' { printf("\tresultado: %s\n", $1); }
;
             
exp:     ENTERO	{ $$ = $1; }
	| exp '+' exp                     { $$ = $1 + $3;  }
	| exp '-' exp                     { $$ = $1 - $3;	}
  | exp '*' exp                     { $$ = $1 * $3;	} 
  |'-'exp                           {$$ = -$2;} 
  |'('exp')'                        {$$ = $2;} 
  | POW"("exp","exp")"           {$$ = pow($3,$5);}
;

expf:   FLOTANTE {$$ = $1;}
  | expf '+' expf      { $$ = $1 + $3;  }
  | expf '-' expf      { $$ = $1 - $3;  }
  | expf '*' expf      { $$ = $1 * $3;  }
  | expf '/' expf      { $$ = $1 / $3;  }  
	| exp '+' expf       { $$ = (float)$1 + $3; }
	| exp '-' expf       { $$ = (float)$1 - $3;	}
  | exp '*' expf       { $$ = (float)$1 * $3;	}
  | exp '/' expf       { $$ = (float)$1 / $3;	} 
	| expf '+' exp       { $$ = $1 + (float)$3; }
	| expf '-' exp       { $$ = $1 - (float)$3;	}
  | expf '*' exp       { $$ = $1 * (float)$3;	}
  | expf '/' exp       { $$ = $1 / (float)$3;	}   
  | exp '/' exp        { $$ = (float)$1 / (float)$3;	}      
  |'-'expf              {$$ = -$2;} 
  |'('expf')'           {$$ = $2;}      
;

exp_str: CADENA {$$ = $1;}
  | exp_str '+' exp_str  {$$ = strcat($1,$3);}
;

%%



int main() {
  yyparse();
}
             
yyerror (char *s)
{
  printf ("--%s--\n", s);
}
            
int yywrap()  
{  
  return 1;  
}  
