/* calc.l */
%{
#define YYSTYPE double /* redefine el tipo de yylval a flotante */
extern YYSTYPE yylval;
#include "y.tab.h" /* Archivo de cabecera es creado por yacc */
#include <stdlib.h>
%}
entero [0-9]+
cadena [A-Za-z]+
exponente [eE][+-]?{entero}
real {entero}("."{entero})?{exponente}?
%%
[ \t]+ ; /* Se ignoran los caracteres en blanco */
{real} { yylval=atof(yytext); return(NUMERO); }
{cadena} {yylval = }
[-+*/~()\n] return(*yytext);
. yyerror("caracter invalido\n");
%%
int yywrap(void)
{
return 1;
}
