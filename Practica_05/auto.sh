flex instrucciones.l
yacc -d instrucciones.y
gcc lex.yy.c y.tab.c -lfl -lm -ly -o Final
rm lex.yy.c y.tab.c y.tab.h
./Final
