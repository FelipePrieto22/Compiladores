%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tamaño = 0;
int valor_leido;
char* cadena_leida;

struct identificadorConValor {
  char* nombre;
  int valor;
}; 

struct identificadorConValor dictionary[100]; 

int getValue(struct identificadorConValor* identifier);
void yyerror(const char *s);
int yylex();
int yywrap();

%}

%token <cadena> CADENA
%token <variable> ID
%token <valor> CONST 
%token INICIO FIN SI ENTONCES LEER ESCRIBIR ASIGNACION PD PI

%union {
  int valor;
  char* cadena;
  struct identificadorConValor* variable;
}

%%

prog: INICIO instrucciones FIN {
  printf("El programa ha sido analizado exitosamente.\n");
  exit(0);
}

instrucciones: instruccion instrucciones
    | instruccion
  ;

instruccion: inst_escribir
    | inst_leer
    | ID ASIGNACION CONST {

      struct identificadorConValor* var = malloc(sizeof(struct identificadorConValor));
      var->nombre = $1->nombre;
      var->valor = $3;
      dictionary[tamaño++] = *var;
    }
  ;

inst_escribir : ESCRIBIR PI ID PD {
  int value = getValue($3);
  printf("\t %d\n", value);
}
    | ESCRIBIR PI CADENA PD {
    printf("\t %s\n", $3); 
}

inst_leer : LEER PI ID PD { 
    scanf("%d", &valor_leido);
    struct identificadorConValor* var = malloc(sizeof(struct identificadorConValor));
    var->nombre = $3;
    var->valor = valor_leido;
    dictionary[tamaño++] = *var;
}

%%

int main() {
    yyparse();
    return 0;
}

int getValue(struct identificadorConValor* identifier) {
    for (int i = 0; i < tamaño; i++) {
        if (strcmp(dictionary[i].nombre, identifier) == 0) {
            return dictionary[i].valor;
        }
    } 
    return 0;
}