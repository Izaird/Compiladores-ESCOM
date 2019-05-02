%{

/*

 * Sample lexical analyzer for a simple calculator.

 * 

 */

#include <stdio.h>

#include <unistd.h>

#include <stdlib.h>

#include <math.h>

#define YYSTYPE double

#include "y.tab.h"



extern int lineno;        /* current line number  */

extern YYSTYPE yylval;    /* value of numeric token */



%}



      digit [0-9]

space [ \t]



%%

{space}         { ; }    /* spaces are ignored */



{digit}+\.?|{digit}*\.{digit}+ { 

                   yylval = strtod(yytext,0); 

                   return NUMBER; }



\*\*            { return '^';  }

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

\n              { lineno++; return '\n'; }



.               { return yytext[0]; }



%%
