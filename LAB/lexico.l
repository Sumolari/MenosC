/* Subseccion preambulo C */
%{
  #include <stdio.h>
  #include "sintaxis.h"
  extern FILE *yyin;
%}

/* Subseccion de definiciones */
%option yylineno

delimiter [\t \n]+

letter [a-zA-Z\_]
digit [0-9]
identifier {letter}({letter}|{digit})*
integerConstant {digit}+

integerType int
booleanType bool

trueValue true
falseValue false

forLoop for

ifCondition if
elseCondition else

readFunction read
printFunction print

semicolon \;
comment \/\/[^\n]*\n
/*sign [+-]*/

andLogicOperator \&\&
orLogicOperator \|\|

assignmentOperator =

equalityOperator ==
inequalityOperator !=

moreThanRelationalOperator >
lessThanRelationalOperator <
moreThanOrEqualRelationalOperator >=
lessThanOrEqualRelationalOperator <=

additiveOperator \+
substractiveOperator \-
multiplicativeOperator \*
divisiveOperator \/

/* positiveUnaryOperator \+ */
/* negativeUnaryOperator \- */
negationUnaryOperator \!

incrementOperator \+\+
decrementOperator \-\-

openingParenthesis \(
closingParenthesis \)

openingBrace \{
closingBrace \}

openingBracket \[
closingBracket \]

%%

"\n"                                { return NEWLINE_; }
{delimiter}                       { return DELIMITER_; }
{integerType}                       { return INT_; }
{booleanType}                       { return BOOL_; }
{trueValue}                       { return TRUE_; }
{falseValue}                        { return FALSE_; }
{forLoop}                           { return FOR_; }
{ifCondition}                       { return IF_; }
{elseCondition}                     { return ELSE_; }
{readFunction}                       { return READ_; }
{printFunction}                     { return PRINT_; }
{semicolon}                         { return SEMICOLON_; }
{andLogicOperator}                  { return AND_; }
{orLogicOperator}                   { return OR_; }
{assignmentOperator}                { return ASSIGN_; }
{equalityOperator}                  { return EQ_; }
{inequalityOperator}                { return NEQ_; }
{moreThanRelationalOperator}        { return GT_; }
{lessThanRelationalOperator}        { return LT_; }
{moreThanOrEqualRelationalOperator} { return GEQ_; }
{lessThanOrEqualRelationalOperator} { return LEQ_; }
{additiveOperator}                  { return ADD_; }
{substractiveOperator}              { return SUB_; }
{multiplicativeOperator}            { return MUL_; }
{divisiveOperator}                  { return DIV_; }
{negationUnaryOperator}             { return NOT_; }
{incrementOperator}                 { return INC_; }
{decrementOperator}                 { return DEC_; }

{openingParenthesis}                { return PAOP_; }
{closingParenthesis}                { return PACL_; }

{openingBrace}                      { return BROP_; }
{closingBrace}                      { return BRCL_; }

{openingBracket}                  { return SQBROP_; }
{closingBracket}                    { return SQBRCL_; }

{identifier}                      { return ID_; }
{integerConstant}                   { return CTE_; }
{comment}                         { return CMNT_; }
.                                   { yyerror("Caracter Desconocido"); }

%%

int main( int argc, char **argv )
{
	if ((yyin = fopen (argv[1], "r")) == NULL)
		fprintf( stderr, "Fichero no valido \%s", argv[1] );
	yyparse();
}