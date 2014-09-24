/* Subseccion preambulo C */
%{
	#include <stdio.h>
	extern FILE *yyin;
	void visualizar(int opcion, char* texto);
%}

/* Subseccion de definiciones */
%option yylineno

letra [a-zA-Z\_]
digito [0-9]
identificador {letra}({letra}|{digito})*
palabraReservada (int|bool|for|else|if|while|true|false|read|print)
constanteEntera {digito}+
delimitador [\t \n]+
comentario \/\/[^\n]*\n
signo [+-]

%%

"\n"               {visualizar(0,"");}
{delimitador}      {ECHO;}
{identificador}    {visualizar(1,"Identificador:");}
{palabraReservada} {visualizar(1,"P. Reservada:");}
{constanteEntera}  {visualizar(1,"Constante Entera:");}
{comentario}       {visualizar(1,"Comentario:");}
{signo}            {visualizar(1,"Signo:");}
.                  {visualizar(1,"Caracter no Valido:");}


%%

void visualizar(int opcion, char* texto)
{
	switch(opcion){
		case 0: printf("%3d- Nueva Linea\n",yylineno);
		break;
		case 1: printf("%3d- \%s \%s\n",yylineno,texto, yytext);
		break;
	}
}

int main (int argc, char **argv)
{
	if ((yyin = fopen (argv[1], "r")) == NULL)
	fprintf (stderr, "Fichero no valido \%s", argv[1]);
	yylex();
}