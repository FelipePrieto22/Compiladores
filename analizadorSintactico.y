%{
#include <stdio.h>
#include <stdlib.h>
#include "lex.yy.c"
#include "common.h" // Incluye el archivo de definición común


%}

%union { int a; }

YYSTYPE yylval;
%token INICIO FIN LEER ESCRIBIR SI ENTONCES IDENTIFICADOR NUMERO CADENA ASIGNACION

%%

Prog : INICIO instrucciones FIN
    ;

instrucciones : instruccion instrucciones
              | instruccion
    ;

instruccion : inst_escribir
            | inst_leer
            | inst_si
            | inst_asign
    ;

inst_escribir : ESCRIBIR '(' cadena_exp ')'
    ;

cadena_exp : CADENA
            | IDENTIFICADOR
    ;

inst_leer : LEER '(' IDENTIFICADOR ')'
    ;

inst_si : SI cond ENTONCES instruccion
    ;

inst_asign : IDENTIFICADOR ASIGNACION exp
    ;

cond : exp '<' exp
    | exp '>' exp
    | exp '=' exp
    ;

exp : term expPrima
    ;

expPrima : '+' term expPrima
         | '-' term expPrima
         |
    ;

term : factor termPrima
    ;

termPrima : '*' factor termPrima
          | '/' factor termPrima
          |
    ;

factor : IDENTIFICADOR
       | NUMERO
    ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
}