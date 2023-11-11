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
};

%type <valor> exp

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
    | inst_si
    | inst_asign
  ;

inst_escribir : ESCRIBIR PI ID PD {
    int value = getValue($3);
    printf("\t %d\n", value);
  }
    | ESCRIBIR PI CADENA PD {
      printf("\t %s\n", $3); 
  }
  ;

inst_leer : LEER PI ID PD { 
    scanf("%d", &valor_leido);
    struct identificadorConValor* var = malloc(sizeof(struct identificadorConValor));
    var->nombre = $3;
    var->valor = valor_leido;
    dictionary[tamaño++] = *var;
  }
  ;

inst_si: SI cond ENTONCES instruccion
  ;

inst_asign: ID ASIGNACION exp {
      int found = 0;
      for (int i = 0; i < tamaño; i++) {
        if (strcmp(dictionary[i].nombre, $1) == 0) {
          dictionary[i].valor = $3;
          found = 1;
          break;
        }
      }
      if (!found) {
        struct identificadorConValor* var = malloc(sizeof(struct identificadorConValor));
        var->nombre = $1;
        var->valor = $3;
        dictionary[tamaño++] = *var;
      }
    }
  ;
  ;

cond : exp '<' exp
    | exp '>' exp
    | exp '=' exp
  ;

exp : exp '+' exp {$$ = $1 + $3;}
    | exp '*' exp {$$ = $1 * $3;}
    | exp '-' exp {$$ = $1 - $3;}
    | exp '/' exp {$$ = $1 / $3;}
    | ID {$$ = getValue($1);}
    | CONST {$$ = $1;}
  ;

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
