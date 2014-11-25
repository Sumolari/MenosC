/*****************************************************************************/
/**  Ejemplo de un posible fichero de cabeceras ("header.h") donde situar   **/
/**  las definiciones de constantes, variables y estructuras globales. Los  **/
/**  alumos deberan adaptarlo al desarrollo de su propio compilador.        **/
/*****************************************************************************/
#ifndef _HEADER_H
#define _HEADER_H
/****************************************************** Constantes generales */
// El tipo ĺogico bool se representa nuḿericamente como un entero: con el
// valor 0, para el caso falso, y 1, para el caso verdad.
#define TRUE  1
#define FALSE 0
// La talla de los tipos simples, entero y l ́ogico, debe estar definida en la
// constante talla tipo simple= 1.
#define TALLA_TIPO_SIMPLE 1
/************************************* Variables externas definidas en el AL */
extern FILE *yyin;
extern int   yylineno;
extern int   yydebug;
extern char *yytext;
/********************* Variables externas definidas en el Programa Principal */
extern int verbosidad;              /* Flag para saber si se desea una traza */
extern int numErrores;              /* Contador del numero de errores        */

int tiposEquivalentes( int tipo_1, int tipo_2 );

#endif  /* _HEADER_H */
/*****************************************************************************/