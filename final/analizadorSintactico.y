%{ 
#include <stdio.h> 
#include <stdlib.h>
void yyerror(const char *s);
int yylex();
int yywrap();

int valor_leido;
%} 

%token <cadena> CADENA
%token <cadena> ID
%token INICIO FIN SI ENTONCES LEER ESCRIBIR CONST ASIGNACION PD PI

%union {
  char* cadena;
  int valor;
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
  ;

inst_escribir : ESCRIBIR PI CADENA PD {
    printf("\t %s\n", $3); 
}

inst_leer : LEER PI ID PD { 
    scanf("%d", &valor_leido);
    printf("\nInstrucción leer: %s\n", &valor_leido); 

}


%%

int main() {
    yyparse();
}
