%{
	#include <stdio.h>
	extern int yylineno;
%}

%error-verbose

%token DELIMITER_
%left CTE_
%left ADD_ SUB_
%left MUL_ DIV_
%left PAOP_ PACL_

%%

s: e { printf( "%d", $1 ); }
e: e ADD_ e { $$ = $1 + $3; }
| e SUB_ e { $$ = $1 - $3; }
| e MUL_ e { $$ = $1 * $3; }
| e DIV_ e { $$ = $1 / $3; }
| PAOP_ e PACL_ { $$ = $2; }
| PAOP_ error PACL_ { }
| CTE_ { $$ = $1; }

%%

/**
 * Llamada por yyparse ante un error
 * @param {char*} s Mensaje de error.
 */
yyerror( char *s )
{
	printf( "Linea %d: %s\n", yylineno, s );
}