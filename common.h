#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>

typedef struct
{
    int i;
    char *s;
} YYSTYPE;

extern YYSTYPE yylval; // Declaración de yylval

void yyerror(const char *s);

#endif
