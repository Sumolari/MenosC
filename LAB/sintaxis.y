%{
	#include <stdio.h>
	#include "header.h"
%}

%error-verbose

%token ID_ SEMICOLON_
%token BROP_ BRCL_
%token INT_ FLOAT_
%token SQBROP_ SQBRCL_
%token ASSIGN_
%token READ_ PRINT_
%token PAOP_ PACL_
%token ADD_
%token AND_
%token BOOL_
%token CTE_
%token DEC_
%token DIV_
%token ELSE_
%token EQ_
%token FOR_
%token GEQ_
%token GT_
%token IF_
%token INC_
%token LEQ_
%token LT_
%token MUL_
%token NEQ_
%token NOT_
%token OR_
%token SUB_
%token TRUE_
%token FALSE_
%token CMNT_

%%

program: BROP_ statementsSequence BRCL_;

statementsSequence: statement | statementsSequence statement;

statement: declaration | instruction;

declaration: simpleType ID_ SEMICOLON_ |
             simpleType ID_ SQBROP_ CTE_ SQBRCL_ SEMICOLON_;

simpleType: INT_ | BOOL_;

instructionList: | instructionList instruction;

instruction: BROP_ instructionList BRCL_ |
             assignmentInstruction |
             inputOutputInstruction |
             selectionInstruction |
             iterationInstruction;

assignmentInstruction: ID_ ASSIGN_ expression SEMICOLON_ |
                       ID_ SQBROP_ expression SQBRCL_ ASSIGN_ expression SEMICOLON_;

inputOutputInstruction: READ_ PAOP_ ID_ PACL_ SEMICOLON_ |
                        PRINT_ PAOP_ expression PACL_ SEMICOLON_;

selectionInstruction: IF_ PAOP_ expression PACL_ instruction ELSE_ instruction;

iterationInstruction: FOR_ PAOP_ optionalExpression SEMICOLON_ expression SEMICOLON_ optionalExpression PACL_ instruction;

optionalExpression: | expression | ID_ ASSIGN_ expression;

expression: equalityExpression | expression logicalOperator equalityExpression;

equalityExpression: relationalExpression |
                    equalityExpression equalityOperator relationalExpression;

relationalExpression: additiveExpression |
                    relationalExpression relationalOperator additiveExpression;

additiveExpression: multiplicativeExpression |
                    additiveExpression additiveOperator multiplicativeExpression;

multiplicativeExpression: unaryExpression |
                          multiplicativeExpression multiplicativeOperator unaryExpression;

unaryExpression: suffixedExpression |
                 unaryOperator unaryExpression |
                 incrementOperator ID_;

suffixedExpression: ID_ SQBROP_ expression SQBRCL_ |
                 PAOP_ expression PACL_ |
                 ID_ | ID_ incrementOperator |
                 CTE_ | TRUE_ | FALSE_;

logicalOperator:        AND_  | OR_;
equalityOperator:       EQ_   | NEQ_;
relationalOperator:     GT_   | LT_ | GEQ_ | LEQ_;
additiveOperator:       ADD_  | SUB_;
multiplicativeOperator: MUL_  | DIV_;
unaryOperator:          ADD_  | SUB_ | NOT_;
incrementOperator:      INC_  | DEC_;

%%
