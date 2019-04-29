
/* escáner para un lenguaje de juguete al estilo de Pascal */

%{
/* se necesita esto para la llamada a atof() más abajo */
// #include <math.h>
%}

Digito          [0-9]
Id              [_a-zA-Z][-_a-z0-9A-Z]*
Decimales       [.][0-9]*
Suma            [0-9]+[+][0-9]+
Resta           [0-9]+[-][0-9]+
Division        [0-9]+[/][0-9]+
Multiplicacion  [0-9]+[*][0-9]+

%%

"+"?{Digito}+   {
            printf( "Un entero positivo: %s \n", yytext);
            }


"-"{Digito}+   {
            printf( "Un entero negativo: %s\n", yytext);
            }

"+"?{Digito}+{Decimales}*    {
            printf( "Decimal positivo: %s\n", yytext);
            }

"-"+{Digito}+{Decimales}*       {
            printf( "Decimal negativo: %s\n", yytext);
            }

"+"?"-"?{Digito}+{Decimales}*"^""+"?{Digito}+   {
            printf( "Potencia positiva: %s\n", yytext);
            }

"+"?"-"?{Digito}+{Decimales}*"^""-"{Digito}+   {
            printf( "Potencia negativa: %s\n", yytext);
            }


{Id}        printf( "Un identificador: %s\n", yytext );
{Suma}        printf( "Una suma: %s\n", yytext );
{Resta}        printf( "Una resta: %s\n", yytext );
{Division}        printf( "Una division: %s\n", yytext );
{Multiplicacion}        printf( "Una multiplicacion: %s\n", yytext );

"MOD("{Digito}+")" {
            printf( "Operacion mod: %s \n", yytext);
            }



"+"|"-"|"*"|"/"   printf( "Un operador: %s\n", yytext );

"{"[^}\n]*"}"     /* se come una linea de comentarios */

[ \t\n]+          /* se come los espacios en blanco */

.           printf( "Caracter no reconocido: %s\n", yytext );
