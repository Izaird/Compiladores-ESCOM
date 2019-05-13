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
Variable [A-Za-z_]+[0-9a-zA-Z_]*
Cadena \"([^"]*)\"


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
                            return (REAL);
                        }
{Cadena} {
	int size = 0,i = 0;
	while(yytext[size]){ size ++; }
	char *aux  = NULL;
	aux = (char*)malloc(size - 1);
	while(yytext[i + 2])
	{
		aux[i] = yytext[i + 1];
		i ++;
	}
	aux[i + 1] = '\0';
	printf("Cadena: %s\n",aux);
	yylval.cadena = aux;
	return (CADENA);
	}

[pP][Oo][Ww]             {  
                            printf("Potencia %s\n",yytext);
                            return POTENCIA;  
                        }

[Ii][Ff]	{
	printf("Comparacion\n");
	return (IF);
	}


[Ii][Nn][Tt]	{
	printf("Declaracion entera\n");
	return (INT);
	}

[Ff][Ll][Oo][Aa][Tt]	{
	printf("Declaracion flotante\n");
	return (FLOAT);
	}

","|"+"|"-"|"/"|"*"|"("|")"|";"|"="	 	{
		                    printf("Signo: %s\n",yytext);
                            return (yytext[0]);
                }

{Variable}	{
	printf("Variable: %s\n",yytext);
	yylval.cadena = yytext;
	return(VARIABLE);
	}

"\n"	{
	printf("Salto de linea\n");	
	return (yytext[0]);
	}

%%
	
