all: tarea

y.tab.c: analizadorSintactico.y
	yacc -d analizadorSintactico.y

lex.yy.c: analizadorLexico.lex
	lex analizadorLexico.lex

tarea: lex.yy.c y.tab.c
	gcc -o tarea lex.yy.c y.tab.c -lfl

clean:
	rm -f tarea lex.yy.c y.tab.c y.tab.h
