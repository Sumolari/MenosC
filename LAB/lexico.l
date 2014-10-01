/* Subseccion preambulo C */
%{
	#include <stdio.h>
	extern FILE *yyin;
	void visualizar(int opcion, char* texto);
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

%%

"\n"                               {visualizar(0,"");}
{delimitador}                      {}
{tipoEntero}                       {visualizar(1, "Tipo entero:");}
{tipoBooleano}                     {visualizar(1, "Tipo booleano:");}
{valorVerdadero}                   {visualizar(1, "Valor verdadero:");}
{valorFalso}                       {visualizar(1, "Valor falso:");}
{bucleFor}                         {visualizar(1, "Bucle for:");}
{condicionIf}                      {visualizar(1, "Condición if:");}
{condicionElse}                    {visualizar(1, "Condición else:");}
{funcionRead}                      {visualizar(1, "Función read:");}
{funcionPrint}                     {visualizar(1, "Función print:");}
{puntoYComa}                       {visualizar(2, "");}
{operadorLogicoY}                  {visualizar(1, "Operador Y:");}
{operadorLogicoO}                  {visualizar(1, "Operador O:");}
{operadorAsignacion}               {visualizar(1, "Operador ASIGNACIÓN:");}
{operadorIgualdad}                 {visualizar(1, "Operador IGUALDAD:");}
{operadorDesigualdad}              {visualizar(1, "Operador DESIGUALDAD:");}
{operadorRelacionalMayorQue}       {visualizar(1, "Operador MAYOR que:");}
{operadorRelacionalMenorQue}       {visualizar(1, "Operador MENOR que:");}
{operadorRelacionalMayorOIgualQue} {visualizar(1, "Operador MAYOR o IGUAL que:");}
{operadorRelacionalMenorOIgualQue} {visualizar(1, "Operador MENOR o IGUAL que:");}
{operadorAditivo}                  {visualizar(1, "Operador suma:");}
{operadorSustractivo}              {visualizar(1, "Operador resta:");}
{operadorMultiplicativo}           {visualizar(1, "Operador producto:");}
{operadorDivisivo}                 {visualizar(1, "Operador división:");}
{operadorUnarioNegacion}           {visualizar(1, "Operador negación:");}
{operadorIncremento}               {visualizar(1, "Operador incremento:");}
{operadorDecremento}               {visualizar(1, "Operador decremento:");}

{aperturaParentesis}               {visualizar(3, "Apertura paréntesis: (");}
{cierreParentesis}                 {visualizar(3, "Cierre paréntesis: )");}

{identificador}                    {visualizar(1, "Identificador:");}
{constanteEntera}                  {visualizar(1, "Constante Entera:");}
{comentario}                       {visualizar(1, "Comentario:");}
.                                  {visualizar(1, "Caracter no Valido:");}


%%

void visualizar(int opcion, char* texto)
{
	switch(opcion){
		case 0: printf("%3d- Nueva Linea\n",yylineno);
		break;
		case 1: printf("%3d- \%s \%s\n",yylineno,texto, yytext);
		break;
		case 2:
		break;
		case 3: printf("%3d- \%s\n",yylineno,texto);
		break;
	}
}

int main (int argc, char **argv)
{
	if ((yyin = fopen (argv[1], "r")) == NULL)
	fprintf (stderr, "Fichero no valido \%s", argv[1]);
	yylex();
}