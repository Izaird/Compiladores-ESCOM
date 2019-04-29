%{
	#include<math.h>
	#include"y.tab.h"
%}

%%
[0-9]+[0-9]*\.[0-9]+ 	{
				yylval.p = atof(yytext);
				return num;	//Regresa un no terminal
			}


sin {return SIN;}
cos {return COS;}
tan return TAN;
log return LOG;
sqrt return SQRT;

[\t];
\n	return 0;
.	return yytext[0];
%%
