/* Subseccion preambulo C */
%{
	#include <stdio.h>
	#include "sintaxis_bison_ii.h"
	extern FILE *yyin;
%}

/* Subseccion de definiciones */
%option yylineno

digito [0-9]
constanteEntera {digito}+

aperturaParentesis \(
cierreParentesis \)

operadorAditivo \+
operadorSustractivo \-
operadorMultiplicativo \*
operadorDivisivo \/

%%

{operadorAditivo}                  { return ADD_; }
{operadorSustractivo}              { return SUB_; }
{operadorMultiplicativo}           { return MUL_; }
{operadorDivisivo}                 { return DIV_; }

{aperturaParentesis}               { return PAOP_; }
{cierreParentesis}                 { return PACL_; }

{constanteEntera}                  { yylval = atoi(yytext); return CTE_; }

.                                  { yyerror("Caracter Desconocido"); }


%%

int main( int argc, char **argv )
{
	if ((yyin = fopen (argv[1], "r")) == NULL)
		fprintf( stderr, "Fichero no valido \%s", argv[1] );
	yyparse();
}