/* Subseccion preambulo C */
%{
	#include <stdio.h>
	#include "sintaxis.h"
	extern FILE *yyin;
%}

/* Subseccion de definiciones */
%option yylineno

delimitador [\t \n]+

letra [a-zA-Z\_]
digito [0-9]
identificador {letra}({letra}|{digito})*
constanteEntera {digito}+

tipoEntero int
tipoBooleano bool

valorVerdadero true
valorFalso false

bucleFor for

condicionIf if
condicionElse else

funcionRead read
funcionPrint print

puntoYComa \;
comentario \/\/[^\n]*\n
/*signo [+-]*/

operadorLogicoY \&\&
operadorLogicoO \|\|

operadorAsignacion =

operadorIgualdad ==
operadorDesigualdad !=

operadorRelacionalMayorQue >
operadorRelacionalMenorQue <
operadorRelacionalMayorOIgualQue >=
operadorRelacionalMenorOIgualQue <=

operadorAditivo \+
operadorSustractivo \-
operadorMultiplicativo \*
operadorDivisivo \/

/* operadorUnarioPositivo \+ */
/* operadorUnarioNegativo \- */
operadorUnarioNegacion \!

operadorIncremento \+\+
operadorDecremento \-\-

aperturaParentesis \(
cierreParentesis \)

aperturaLlave \{
cierreLlave \}

aperturaCorchete \[
cierreCorchete \]

%%

"\n"                               { return NEWLINE_; }
{delimitador}                      { return DELIMITER_; }
{tipoEntero}                       { return INT_; }
{tipoBooleano}                     { return BOOL_; }
{valorVerdadero}                   { return TRUE_; }
{valorFalso}                       { return FALSE_; }
{bucleFor}                         { return FOR_; }
{condicionIf}                      { return IF_; }
{condicionElse}                    { return ELSE_; }
{funcionRead}                      { return READ_; }
{funcionPrint}                     { return PRINT_; }
{puntoYComa}                       { return SEMICOLON_; }
{operadorLogicoY}                  { return AND_; }
{operadorLogicoO}                  { return OR_; }
{operadorAsignacion}               { return ASSIGN_; }
{operadorIgualdad}                 { return EQ_; }
{operadorDesigualdad}              { return NEQ_; }
{operadorRelacionalMayorQue}       { return GT_; }
{operadorRelacionalMenorQue}       { return LT_; }
{operadorRelacionalMayorOIgualQue} { return GEQ_; }
{operadorRelacionalMenorOIgualQue} { return LEQ_; }
{operadorAditivo}                  { return ADD_; }
{operadorSustractivo}              { return SUB_; }
{operadorMultiplicativo}           { return MUL_; }
{operadorDivisivo}                 { return DIV_; }
{operadorUnarioNegacion}           { return NOT_; }
{operadorIncremento}               { return INC_; }
{operadorDecremento}               { return DEC_; }

{aperturaParentesis}               { return PAOP_; }
{cierreParentesis}                 { return PACL_; }

{aperturaLlave}                    { return BROP_; }
{cierreLlave}                      { return BRCL_; }

{aperturaCorchete}                 { return SQBROP_; }
{cierreCorchete}                   { return SQBRCL_; }

{identificador}                    { return ID_; }
{constanteEntera}                  { return CTE_; }
{comentario}                       { return CMNT_; }
.                                  { yyerror("Caracter Desconocido"); }


%%

int main( int argc, char **argv )
{
	if ((yyin = fopen (argv[1], "r")) == NULL)
		fprintf( stderr, "Fichero no valido \%s", argv[1] );
	yyparse();
}