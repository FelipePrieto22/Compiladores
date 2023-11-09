%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "common.h" // Incluye el archivo de definición común


%}

%%

inicio   { return INICIO; }
fin      { return FIN; }
leer     { return LEER; }
escribir { return ESCRIBIR; }
si       { return SI; }
entonces { return ENTONCES; }
[A-Z][0-9]+ { yylval.s = strdup(yytext); return IDENTIFICADOR; }
[0-9]+     { yylval.i = atoi(yytext); return NUMERO; }
\"[^\"]*\" { yylval.s = strdup(yytext); return CADENA; }
"<-"       { return ASIGNACION; }
[-+*/]     { return yytext[0]; } // Tokens para operaciones aritméticas
[><=]      { return yytext[0]; } // Tokens para operaciones relacionales

[ \t\n]    { /* Ignora espacios en blanco y saltos de línea */ }
.          { yyerror("Carácter ilegal"); }

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error léxico: %s\n", s);
}
