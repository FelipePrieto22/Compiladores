{
    - %
    {
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lex.yy.c" // Incluye el archivo de análisis léxico

        char outputBuffer[1024];

        void addToOutputBuffer(const char *text)
        {
            strncat(outputBuffer, text, 1024 - strlen(outputBuffer) - 1);
        }

        void printOutputBuffer()
        {
            printf("%s\n", outputBuffer);
            outputBuffer[0] = '\0';
        }

        %
    }

    % token INICIO FIN LEER ESCRIBIR SI ENTONCES IDENTIFICADOR NUMERO CADENA ASIGNACION

        % %

        programa : INICIO instrucciones FIN
    {
        printOutputBuffer();
    }

instrucciones:
    instruccion instrucciones | instruccion;

instruccion:
    inst_escribir | inst_leer | inst_si | inst_asig;

inst_escribir:
    ESCRIBIR '(' cadena_expr ')'
    {
        const char *cadena = (const char *)$3; // Accede al valor de $3 como una cadena
        addToOutputBuffer(cadena);
    }

cadena_expr:
    IDENTIFICADOR
    | CADENA;

inst_leer:
    LEER IDENTIFICADOR
    {
        // Realiza la lectura y almacena el valor en la variable IDENTIFICADOR
        char buffer[1024];
        printf("Ingrese un valor: ");
        scanf("%s", buffer);
        yylval = strdup(buffer);
    }

inst_si:
    SI cond ENTONCES instruccion
    {
        if ($2)
        {
            const char *instruccion = (const char *)$4;
            addToOutputBuffer(instruccion);
        }
    }

cond:
    exp '<' exp { $$ = $$ < $3; }
    | exp '>' exp { $$ = $$ > $3; }
    | exp '=' exp { $$ = $$ == $3; };

exp:
    IDENTIFICADOR expPrima{/* Realizar operaciones aritméticas con $1 y $2 */} | NUMERO expPrima{/* Realizar operaciones aritméticas con $1 y $2 */};

expPrima:
    '+' exp{/* Realizar suma con $2 y $1 */} | '-' exp{/* Realizar resta con $2 y $1 */} | '*' exp{/* Realizar multiplicación con $2 y $1 */} | '/' exp{/* Realizar división con $2 y $1 */} | /* vacío */
        ;

inst_asig:
    IDENTIFICADOR ASIGNACION exp{/* Realizar asignación de valor a la variable $1 */};

    % %

        main()
    {
        return (yyparse());
    }

    yyerror(s) char *s;
    {
        fprintf(stderr, "%s\n", s);
    }

    yywrap()
    {
        return (1);
    }
    -
}