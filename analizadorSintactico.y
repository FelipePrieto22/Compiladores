%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tamaño = 0;
int valor_leido;
int condicional = 1;
char* cadena_leida;

struct tablaDeSimbolos {
  char* nombre;
  int valor;
}; 

struct tablaDeSimbolos dictionary[100]; 
int getValue(char* identifier);
void yyerror(const char *s);
int yylex();
int yywrap();

%} 

%left '+' '-'
%left '*' '/' 

%token <cadena> CADENA ID
%token <valor> CONST
%token INICIO FIN SI ENTONCES LEER ESCRIBIR ASIGNACION PD PI

%union {
  int valor;
  char* cadena;
  struct tablaDeSimbolos* variable;
};

%type <valor> exp cond
%type <valor> instruccion inst_si inst_asign inst_leer inst_escribir

%%


prog: INICIO instrucciones FIN {
  printf("\nEl programa ha sido analizado exitosamente.\n");
  printf("\nTabla de analisis sintactico:\nID\tValor\n");
  for (int i = 0; i < tamaño; i++) {
    printf("%s \t%d \n",dictionary[i].nombre ,dictionary[i].valor);
  }
  printf("\n");
  exit(0);
}

instrucciones: instruccion instrucciones
    | instruccion
  ;

instruccion: inst_si 
    | inst_escribir
    | inst_leer
    | inst_asign
  ;

inst_escribir : ESCRIBIR PI ID PD {
    if(condicional){
      int value = getValue($3);
      printf("\t %d\n", value);
    }
  }
    | ESCRIBIR PI CADENA PD {
      if(condicional){
        printf("\t %s\n", $3); 
      }
  }
  ;

inst_leer : LEER PI ID PD { 
  if(condicional){
    int found = 0;
    for (int i = 0; i < tamaño; i++) {
      if (strcmp(dictionary[i].nombre, $3) == 0) {
        scanf("%d", &valor_leido);
        dictionary[i].valor = valor_leido;
        found = 1;
        break;
      }
    }
    if (!found) {
      scanf("%d", &valor_leido);
      struct tablaDeSimbolos* var = malloc(sizeof(struct tablaDeSimbolos));
      var->nombre = $3; 
      var->valor = valor_leido;
      dictionary[tamaño++] = *var;
    }    
  }
}
;

inst_si: SI cond ENTONCES instruccion {
    if ($2) {
      $$ = $4;
    }
    if(!condicional){
      condicional = 1;
    }
  }
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
        struct tablaDeSimbolos* var = malloc(sizeof(struct tablaDeSimbolos));
        var->nombre = $1; 
        var->valor = $3;
        dictionary[tamaño++] = *var; 
    }
} 
;

cond : exp '<' exp {condicional = $1 < $3;}
    | exp '>' exp {condicional = $1 > $3;}
    | exp '=' exp {condicional = $1 == $3;}
  ;

exp : exp '*' exp {$$ = $1 * $3;}
    | exp '/' exp {$$ = $1 / $3;}
    | exp '+' exp {$$ = $1 + $3;}
    | exp '-' exp {$$ = $1 - $3;}
    | ID {$$ = getValue($1);}
    | CONST {$$ = $1;}
    ;


%%

int main() {
  printf("Manual de usuario:\n\n");
  printf("-Identificadores: son de la forma una letra mayuscula de la A a la Z seguida de un digito del 0 al 9\n\n");
  printf("-Constrantes: son cualquier combinacion de digitos\n\n");
  printf("INSTRUCCIONES:\n\n");
  printf("-Asignacion: para asignar usa :=, por ejemplo A1 := 3, esto asigna a A1 el valor 3\n\n");
  printf("-Escribir: puedes escribir en pantalla un identificador o cadena, por ejemplo escribir(\"Hola\") muestra Hola o tambien escribir(A1) muestra 3\n\n");
  printf("-Leer: puedes utilizar leer para ingresar desde pantalla un valor y asignarlo al identificador, por ejemplo leer(A1) 35, esto asigna a A1 el valor 35 que se ingresa en el terminal\n\n");
  printf("-Si: puedes realizar un si cond entonces instruccion, donde cond es una condicion usando <,> o = y instruccion son las mencionadas anteriormente, por ejemplo si 1 < 4 entonces escribir(\"hola\"), esto mostrara Hola en el terminal\n\n");
  printf("--------------------------------------------------------------------------\n");
  printf("Escribe tu programa a analizar:\n\n"); 
  yyparse();
  return 0;
}

int getValue(char* identifier) {
    for (int i = 0; i < tamaño; i++) {
        if (strcmp(dictionary[i].nombre, identifier) == 0) {
            return dictionary[i].valor;
        }
    } 
    return 0;
}