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
if [Ii][Ff]
int [Ii][Nn][Tt]
float [Ff][Ll][Oo][Aa][Tt]
string [Ss][Tt][Rr][Ii][Nn][Gg]
variable [A-Za-z_]+[0-9a-zA-Z_]*
tabla [t][@][b]

%%

{espacio}               { ; }    /* espacios son ignorados */


{numero}                   {
                            // printf("Numero entero %s\n",yytext);
                            yylval.entero = atoi(yytext);
                            return (ENTERO);
                        }

({numero})(".")({numero})    {
                            // printf("Numero flotante %s\n",yytext);
                            yylval.flotante = strtod(yytext, NULL);
                            return (RACIONAL);
                        }

\"([^"]*)\"             {
                            int i = 0;
                            char *str = NULL;
                            str = (char *) malloc(yyleng-1);
                            yylval.cadena = str;
                            yytext++;
                            for(i = 0; i < yyleng-2; i++){
                                *str = *yytext;
                                str++;
                                yytext++;
                            }
                            *str = '\0';
                            // printf("Cadena: %s\n", yylval.cadena);
                            return(CADENA);
                        }

{potencia} 	{
	// printf("Potencia\n");
	return (POW);
	}

{if} 	{
	// printf("Comparacion\n");
	return (IF);
	}


{int} 	{
	// printf("Declaracion entera\n");
	return (INT);
	}

{float} 	{
	// printf("Declaracion flotante\n");
	return (FLOAT);
	}

{string} 	{
	// printf("Declaracion string\n");
	return (STRING);
	}


{variable}	{
	// printf("Variable: %s\n",yytext);
	yylval.cadena = yytext;
	return(VARIABLE);
	}

{tabla}	{
	// printf("Variable: %s\n",yytext);
	return(TABLA);
	}
                            
"+"|"-"|"/"|"*"|"^"|"("|")"|"="|"<"|">"|","|";"	 	{
		                    // printf("Signo: %s\n",yytext);
                            return (yytext[0]);
                }






"\n"	{
	// printf("Salto de linea\n");	
	return (yytext[0]);
	}

%%
	