/* Subseccion preambulo C */
%{
  #include <stdio.h>
  #include <string.h>
  #include "../tmp/sintaxis.h"
%}

/* Subseccion de definiciones */
%option yylineno

delimiter [\t \n]+

letter [a-zA-Z\_]
digit [0-9]
identifier {letter}({letter}|{digit})*
integerConstant {digit}+
floatConstant ({digit}+)?\.{digit}+

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

"\n"                                {}
{delimiter}                         {}
{integerType}                       { return INT_; }
{booleanType}                       { return BOOL_; }
{trueValue}                         { yylval.cent = 1; return TRUE_; }
{falseValue}                        { yylval.cent = 0; return FALSE_; }
{forLoop}                           { return FOR_; }
{ifCondition}                       { return IF_; }
{elseCondition}                     { return ELSE_; }
{readFunction}                      { return READ_; }
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

{openingBracket}                    { return SQBROP_; }
{closingBracket}                    { return SQBRCL_; }

{identifier}                        {
										if ( strlen( yytext ) > 14 ) {
											yywarn( "Identificador excesivo" );
										}
										char *pnt = malloc( 15 * sizeof(char) );
										yylval.ident = pnt;
 										strncpy( yylval.ident, yytext, 14);
 										return ID_;
 									}
{integerConstant}                   {
										yylval.cent = atoi( yytext );
										return CTE_;
									}
{floatConstant}						{
										yywarn( "Real truncado" );
										yylval.cent = atoi( yytext );
										return CTE_;
									}
{comment}                           { }
.                                   { yyerror("Caracter desconocido"); }

%%