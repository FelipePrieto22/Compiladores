EJECUCION DE CODIGO:

1- Intalar compilador lex -> sudo apt-get install flex desde subsistema linux
2- Compilar el archivo.lex -> lex archivo.lex -> genera un archivo lex.yy.c es decir un archivo para compilar con C
3- compilar el archivo lex.yy.c con cc lex.yy.c -ll -o tarea generando el output tarea
4- Ejecutar el archivo ./tarea

lex analizador.l
yacc -d analizadorSintactico.y
gcc -o tarea lex.yy.c y.tab.c -lfl
