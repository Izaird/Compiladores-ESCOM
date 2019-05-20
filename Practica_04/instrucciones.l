%{
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <math.h>
#include "y.tab.h"

extern int lineno;        /* Actual numero de linea  */
extern YYSTYPE yylval;    /* Valor numerico del token */
%}

numero [0-9]+
espacio [ \t]
potencia [pP][Oo][Ww]

%%

{espacio}               { ; }    /* espacios son ignorados */


{numero}                   {
                            printf("Numero entero %s\n",yytext);
                            yylval.entero = atoi(yytext);
                            return (ENTERO);
                        }

({numero})(".")({numero})    {
                            printf("Numero flotante %s\n",yytext);
                            yylval.flotante = strtod(yytext, NULL);
                            return (RACIONAL);
                        }

\"([^"]*)\"             {
                            int i = 0;
                            char *str = NULL;
                            str = (char *) malloc(yyleng-1);
                            yylval.string = str;
                            yytext++;
                            for(i = 0; i < yyleng-2; i++){
                                *str = *yytext;
                                str++;
                                yytext++;
                            }
                            *str = '\0';
                            printf("Cadena: %s\n", yylval.string);
                            return(CADENA);
                        }


{potencia}              {  
                            printf("Potencia %s\n",yytext);
                            return POW;  
                        }
"+"|"-"|"/"|"*"|"^"|"("|")"|"="|"<"|">"|","|";"	 	{
		                    printf("Signo: %s\n",yytext);
                            return (yytext[0]);
                }

cos             { return COS;  }

exp             { return EXP;  }

sin             { return SIN;  }

sqrt            { return SQRT; }

tan             { return TAN;  }

pi              { yylval.flotante = atan(1.0)*4; 
                  return FLOTANTE; }

e               { yylval.flotante = exp(1.0);    
                  return FLOTANTE; }

\n              { lineno++; return '\n'; } //Se va incrementando cada salto de linea





%%
