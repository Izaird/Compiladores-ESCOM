/* calc.y */
%{
#define YYSTYPE double /* redefine el tipo de yylval */
extern YYSTYPE yylval;
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}
%token NUMERO
%left '+' '-'
%left '*' '/'
%left NEG
%right '~'
%start prog
%%
prog: /* Vacio */
| prog expr '\n' { printf("Resultado: %f\n",$2); }
;
expr: NUMERO { $$=$1; }
| expr '+' expr { $$=$1+$3; }
| expr '-' expr { $$=$1-$3; }
| expr '*' expr { $$=$1*$3; }
| expr '/' expr { $$=$1/$3; }
| '-' expr %prec NEG { $$=-$2; }
| expr '~' expr { $$=pow($1,$3); }
| '(' expr ')' { $$=$2; }
;
%%
int yyerror(char *msje) {
printf("%s\n",msje);
}
int main(void) {
yyparse();
return 0;
}
