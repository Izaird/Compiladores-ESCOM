echo "Nombre del scanner"
read scanner
flex ${scanner}.l
gcc lex.yy.c -lfl -o ${scanner}
./${scanner}
