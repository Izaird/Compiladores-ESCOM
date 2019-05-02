%{
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <math.h>
#define YYSTYPE double
#include "y.tab.h"

extern int lineno;        /* Actual numero de linea  */
extern YYSTYPE yylval;    /* Valor numerico del token */
%}



numero [0-9]
espacio [ \t]
potencia [pP][Oo][Ww]


%%

{espacio}         { ; }    /* espacios son ignorados */



{numero}+\.?|{numero}*\.{numero}+ { 
                   yylval = strtod(yytext,0); 
                   return NUMBER; }


{potencia}      { return POW;  }

last            { return LAST; }

cos             { return COS;  }

exp             { return EXP;  }

sin             { return SIN;  }

sqrt            { return SQRT; }

tan             { return TAN;  }

pi              { yylval = atan(1.0)*4; 
                  return NUMBER; }

e               { yylval = exp(1.0);    
                  return NUMBER; }

\n              { lineno++; return '\n'; } //Se va incrementando cada salto de linea


.               { return yytext[0]; }



%%
