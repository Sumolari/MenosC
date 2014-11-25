/*****************************************************************************/
/*  Ejemplo de n posible programa principal y su tratamiento de errores.     */
/*                                                                           */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include "header.h"

int verbosidad = FALSE;             /* Flag para saber si se desea una traza */
int numErrores = 0;                 /* Contador del numero de errores        */
/*****************************************************************************/
void yyerror( const char * msg )
/*  Tratamiento de errores.                                                  */
{
	numErrores++;
	fprintf( stdout, "Linea %d: %s\n", yylineno, msg );
}
/*****************************************************************************/
int main( int argc, char **argv )
/* Gestiona la linea de comandos e invoca al analizador sintactico-semantico.*/
{ int i, n = 0;

	for ( i = 0; i < argc; ++i ) {
		if ( strcmp( argv[ i ], "-v" ) == 0 ) { verbosidad = TRUE; n++; }
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
	else fprintf (stderr, "Uso: ./analizador [-v] fichero\n");
}
/*****************************************************************************/
int tiposEquivalentes( int tipo_1, int tipo_2 ) {
	if ( tipo_1 == tipo_2 ) {
		return 1;
	} else {
		if ( verbosidad == TRUE ) {
			printf(
				"Tipo incompatible: se esperaba %d pero se ha encontrado %d\n",
				tipo_2,
				tipo_1
			);
		}
		yyerror( "Tipo incompatible" );
		return 0;
	}
}
/*****************************************************************************/