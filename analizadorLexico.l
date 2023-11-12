%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
void yyerror(const char* s);
int yywrap();
%}

%%

[0-9]+ { yylval.valor = atoi(yytext); return CONST; }
[A-Z][0-9] { yylval.cadena = strdup(yytext); return ID; }

["](.*)["]  { yylval.cadena = strdup(yytext + 1); yylval.cadena[strlen(yytext) - 2] = '\0'; return CADENA; }

"inicio" { return INICIO; }
"fin" { return FIN; }
"si" { return SI; }
"entonces" { return ENTONCES; }
"leer" { return LEER; }
"escribir" { return ESCRIBIR; }
":=" { return ASIGNACION; } 

[ \t\n] ;
[-+*/=<>] {return yytext[0];}
"(" { return PI; }
")" { return PD; }
. { yyerror("Carácter ilegal"); }

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int yywrap() {
    return 1;
}
