rm Final
flex Instrucciones.l
yacc -d Instrucciones.y
gcc lex.yy.c y.tab.c -lfl -lm -ly -o Final
rm lex.yy.c y.tab.c y.tab.h
./Final < in

