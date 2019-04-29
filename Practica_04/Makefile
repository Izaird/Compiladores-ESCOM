run: salida
		./salida
salida: lex.yy.c y.tab.c
		gcc lex.yy.c y.tab.c -o salida -ly -ll -lm
y.tab.c:
		yacc -d instrucciones.y
lex.yy.c:
		flex instrucciones.l
clean:
		rm lex.yy.c
		rm y.tab.c
		rm y.tab.h
		rm salida
		clear 
