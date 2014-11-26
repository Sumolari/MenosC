/*****************************************************************************/
/*  Ejemplo de n posible programa principal y su tratamiento de errores.     */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include "../include/header.h"
#include "../include/libtds.h"

int verbosidad = FALSE;             /* Flag para saber si se desea una traza */
int numErrores = 0;                 /* Contador del numero de errores        */
int numAlertas = 0;                 /* Contador del numero de alertas        */
/*****************************************************************************/
void yyerror( const char * msg )
/*  Tratamiento de errores.                                                  */
{
	numErrores++;
	fprintf( stdout, "Linea %d: %s\n", yylineno, msg );
}
/*****************************************************************************/
void yywarn( const char * msg )
/*  Tratamiento de alertas.                                                  */
{
	numAlertas++;
	fprintf( stdout, "Linea %d: %s\n", yylineno, msg );
}
/*****************************************************************************/
int main( int argc, char **argv )
/* Gestiona la linea de comandos e invoca al analizador sintactico-semantico.*/
{ int i, n = 0;

	for ( i = 0; i < argc; ++i ) {
		if ( strcmp( argv[ i ], "-v" ) == 0 ) { verbosidad = TRUE; n++; }
		//else if ( strcmp( argv[ i ], "-t" ) == 0 ) { verTDS = TRUE; n++; }
	}
	--argc; n++;
	if ( argc == n ) {
		if ( ( yyin = fopen( argv[ argc ], "r" ) ) == NULL )
			fprintf( stderr, "Fichero no valido %s\n", argv[ argc ] );
		else {
			if ( verbosidad == TRUE ) fprintf( stdout, "%3d.- ", yylineno );
			yyparse ();
			if ( numErrores > 0 )
				fprintf( stdout, "\nNumero de errores:      %d\n", numErrores );
		}
	}
	else fprintf (stderr, "Uso: ./analizador [-v] [-t] fichero\n");
}
/*****************************************************************************/