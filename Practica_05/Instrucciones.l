%{
	#include <stdio.h>
	#include "y.tab.h"
%}

NUM [0-9]+
Real [0-9]*"."[0-9]+
Variable [A-Za-z_]+[0-9a-zA-Z_]*
Cadena \"([^"]*)\"

%%

{Real}	{
	//printf("Numero real: %s\n",yytext);
	yylval.flotante = strtof(yytext, NULL);
	return (REAL);
	}

{NUM} {
	//printf("Numero entero: %s\n",yytext);
	yylval.entero = atoi(yytext);
	return (ENTERO);
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
	//printf("Cadena: %s\n",aux);
	yylval.cadena = aux;
	return (CADENA);
	}

[Pp][Oo][Ww]	{
	//printf("Potencia\n");
	return (POTENCIA);
	}

[Ii][Ff]	{
	//printf("Comparacion\n");
	return (IF);
	}


[Ii][Nn][Tt]	{
	//printf("Declaracion entera\n");
	return (INT);
	}

[Ff][Ll][Oo][Aa][Tt]	{
	//printf("Declaracion flotante\n");
	return (FLOAT);
	}

[Ss][Tt][Rr][Ii][Nn][Gg]	{
	printf("Declaracion string\n");
	return (STRING);
	}

"+" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

"-"  {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

"^" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

"*" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

">" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

"<" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

"/" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

"=" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

"(" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

")" {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

"," {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}

";"  {
	//printf("Simbolo: %s\n",&yytext[0]);
	return(yytext[0]);
	}




{Variable}	{
	//printf("Variable: %s\n",yytext);
	yylval.cadena = yytext;
	return(VARIABLE);
	}

"\n"	{
	//printf("Salto de linea\n");	
	return (yytext[0]);
	}

%%
	