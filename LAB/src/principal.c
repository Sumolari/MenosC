/*****************************************************************************/
/*  Ejemplo de n posible programa principal y su tratamiento de errores.     */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include "../include/header.h"
#include "../include/libtds.h"
#include "../include/libgci.h"

int verbosidad = FALSE;         /* Flag para saber si se desea una traza     */
int verTDS = FALSE;             /* Flag para saber si se debe mostrar la TDS */
int numErrores = 0;             /* Contador del numero de errores            */
int numAlertas = 0;             /* Contador del numero de alertas            */
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
void yywrap() {}    /* Para poder compilar sin -lfl (problematico en CentOS) */
/*****************************************************************************/
int main( int argc, char **argv )
/* Gestiona la linea de comandos e invoca al analizador sintactico-semantico.*/
{
	char *nom_sal;
	int i, n = 0;

	for ( i = 0; i < argc; ++i ) {
		if ( strcmp( argv[ i ], "-v" ) == 0 ) { verbosidad = TRUE; n++; }
		else if ( strcmp( argv[ i ], "-t" ) == 0 ) { verTDS = TRUE; n++; }
	}
	--argc; n++;
	if ( argc == n + 1 ) {
		if ( ( yyin = fopen( argv[ argc - 1 ], "r" ) ) == NULL )
			fprintf( stderr, "Fichero no valido %s\n", argv[ argc - 1 ] );
		else {
			if ( verbosidad == TRUE ) fprintf( stdout, "%3d.- ", yylineno );
			nom_sal  = argv[ argc ];

			yyparse ();
			if ( numErrores > 0 )
				fprintf( stdout, "\nNumero de errores:      %d\n", numErrores );
			else
				volcarCodigo( nom_sal );
		}
	}
	else fprintf (stderr, "Uso: ./analizador [-v] [-t] fichero salida\n");
}
/*****************************************************************************/