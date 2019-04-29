%{
	#include<stdio.h>
	#include<math.h>
%}

%union
{double p;}
%token<p>num
%token SIN COS TAN LOG SQRT

%left '+''-'
%left '*''/'
%nonassoc uminu
%type<p>exp

%%

ss : exp {printf("La respuesta es:%g\n",$1);}


exp	:	 exp'+'exp			{$$=$1+$3;}
    		|exp'-'exp			{$$=$1-$3;}
		|exp'*'exp			{$$=$1*$3;}
		|exp'/'exp			{
							if($3==0){
								printf("No se puede divir entre 0");
							}
							else $$=$1/$3;
						}
		|'-'exp				{$$=-$2;}
		|SIN'('exp')'			{$$=sin($3);}
		|COS'('exp')'			{$$=cos($3);}
		|TAN'('exp')'			{$$=tan($3);}
		|LOG'('exp')'			{$$=log($3);}
		|SQRT'('exp')'			{$$=sqrt($3);}
		|'(' exp ')'			{$$=$2;}
		|num;
%%


main(){
	do{
		printf("\nIntroduzca la expresion:");
		yyparse();
	}while(1);
}


yyerror(char *s;){
	printf("Syntax ERROR");
}
