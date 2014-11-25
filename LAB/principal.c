/*****************************************************************************/
/*  Ejemplo de n posible programa principal y su tratamiento de errores.     */
/*                                                                           */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include "header.h"
#include "libtds.h"

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
	if ( tipo_1 == T_ERROR || tipo_2 == T_ERROR ) {
		return 0;
	} if ( tipo_1 == tipo_2 ) {
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
int existeTDS(char *nom) {
	SIMB s = obtenerTDS(nom);
	return s.tipo != T_ERROR;
}
/*****************************************************************************/
int comprobarTipo( char *nom, int tipo_esperado ) {

	/* TOOD: Fix this!
	printf("A por el tipito\n");
	mostrarTDS();
	obtenerTDS(nom);
	mostrarTDS();
	printf("Nanai");
	*/

	if ( !existeTDS( nom ) ) {
		yyerror( "Variable no declarada" );
		return 0;
	}

	// Comprobar que el tipo no sea un error.
	if ( obtenerTDS( nom ).tipo == T_ERROR || tipo_esperado == T_ERROR ) {
		return 0;
	}

	// Comprobar que el tipo es compatible.
	if ( obtenerTDS( nom ).tipo != tipo_esperado ) {
		if ( verbosidad == TRUE ) {
			printf(
				"Tipo incompatible: se esperaba %d pero %s es %d\n",
				tipo_esperado,
				nom,
				obtenerTDS( nom ).tipo
			);
		}
		yyerror( "Tipo incompatible" );
		return 0;
	}
	return 1;
}
/*****************************************************************************/