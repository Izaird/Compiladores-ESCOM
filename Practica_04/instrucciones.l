%{
#include "y.tab.h"
#include <stdio.h>
%}

Entero [0-9]+
Flotante [0-9]+.[0-9]+
%%

{Entero}             {
		printf("Numero entero %s\n",yytext);
                yylval.entero = atoi(yytext);
                return (ENTERO);
                }

{Flotante}    {
		printf("Numero flotante %s\n",yytext);
                yylval.flotante = atof(yytext);
                return (FLOTANTE);
                }


"+"	 	{
		printf("Signo suma\n");
                return (yytext[0]);
                }

"-"	 	{
		printf("Signo resta\n");
                return (yytext[0]);
                }

"*"	 	{
		printf("Signo mult\n");
                return (yytext[0]);
                }


"/"	 	{
		printf("Signo div\n");
                return (yytext[0]);
                }

\"([^"]*)\"       {
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
"d"+"dd"
"\n"            {
		printf("Salto de linea\n");
                return (yytext[0]);
                }
%%

