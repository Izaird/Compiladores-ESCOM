
/* escáner para un lenguaje de juguete al estilo de Pascal */

%{
/* se necesita esto para la llamada a atof() más abajo */
#include <math.h>
%}

DIGITO   [0-9]
ID       [-_a-zA-Z][a-z0-9A-Z]*

%%

{DIGITO}+   {
            printf( "Un entero: %s (%d)\n", yytext,
                    atoi( yytext ) );
            }

{DIGITO}+"."{DIGITO}*      {
            printf( "Un real: %s (%g)\n", yytext,
                    atof( yytext ) );
            }


if|then|begin|end|procedure|function|clear       {
            printf( "Una palabra clave: %s\n", yytext );
            }

{ID}        printf( "Un identificador: %s\n", yytext );

"+"|"-"|"*"|"/"   printf( "Un operador: %s\n", yytext );

"{"[^}\n]*"}"     /* se come una linea de comentarios */

[ \t\n]+          /* se come los espacios en blanco */

.           printf( "Caracter no reconocido: %s\n", yytext );
