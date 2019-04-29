%{
	#include<stdio.h>
	#include<math.h>
%}

%union
{double p;}
%token <p> num


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
								prinft("No se puede divir entre 0");
							}
							else $$=$1/$3;
						}
		|'-'exp				{$$=-$2;}
		|num;
		|'(' exp ')'			{$$=$2;}

%%


main(){
	do{
		printf("\nIntroduzca la expresion:");
		yyparse();
	}while(1);
}


yyerror(char *s;){
	prinft("Syntax ERROR");
}
